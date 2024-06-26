import formError from "$lib/server/formError"
import { auth } from "$lib/server/lucia"
import requestRender from "$lib/server/requestRender"
import { Record, equery, findWhere, surql } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import createUserQuery from "./createUser.surql"

const createRegkeyUserQuery = `${createUserQuery}
	UPDATE ONLY $key SET usesLeft -= 1;
	RELATE $u->used->$key`

const schemaInitial = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	password: z.string().min(1).max(6969),
	cpassword: z.string().min(1).max(6969),
})
const schema = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	email: z.string().email(),
	password: z.string().min(1).max(6969),
	cpassword: z.string().min(1).max(6969),
	regkey: z.string().min(1).max(6969),
})

type CreatedUser = {
	username: string
	email: string
	hashedPassword: string
	permissionLevel: number
	currency: number
}

async function createUser(user: CreatedUser, keyUsed?: string) {
	const q = await equery<{ number: number; id: string }[]>(
		keyUsed ? createRegkeyUserQuery : createUserQuery,
		{ user, key: keyUsed ? Record("regKey", keyUsed) : undefined }
	)
	return q[3]
}

async function isAccountRegistered() {
	const [userCount] = await equery<number[]>(surql`count(SELECT 1 FROM user)`)
	return userCount > 0
}

export const load = async () => ({
	form: await superValidate(zod(schema)),
	users: await isAccountRegistered(),
})

export const actions: import("./$types").Actions = {}
actions.register = async ({ request, cookies }) => {
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)
	const { username, email, password, cpassword, regkey } = form.data

	if (cpassword !== password)
		return formError(
			form,
			["password", "cpassword"],
			[" ", "The specified passwords do not match"]
		)

	const userCheck = await findWhere("user", "username = $username", {
		username,
	})

	if (userCheck)
		return formError(
			form,
			["username"],
			["This username is already in use"]
		)

	const emailCheck = await findWhere("user", "email = $email", { email })

	if (emailCheck)
		return formError(form, ["email"], ["This email is already in use"])

	const [[regkeyCheck]] = await equery<{ usesLeft: number }[][]>(
		surql`SELECT usesLeft FROM ${Record("regKey", regkey.split("-")[1])}`
	)

	if (!regkeyCheck)
		return formError(form, ["regkey"], ["Registration key is invalid"])
	if (regkeyCheck.usesLeft < 1)
		return formError(
			form,
			["regkey"],
			["This registration key has ran out of uses"]
		)

	const user = await createUser(
		{
			username,
			email,
			// I still love scrypt, though argon2 is better supported
			hashedPassword: Bun.password.hashSync(password),
			permissionLevel: 1,
			currency: 0,
		},
		regkey
	)

	try {
		await requestRender("Avatar", user.number)
	} catch {}

	const session = await auth.createSession(user.id, {})
	const sessionCookie = auth.createSessionCookie(session.id)

	cookies.set(sessionCookie.name, sessionCookie.value, {
		path: ".",
		...sessionCookie.attributes,
	})

	redirect(302, "/home")
}
// This is the initial account creation, which is only allowed if there are no existing users.
actions.initialAccount = async ({ request, cookies }) => {
	const form = await superValidate(request, zod(schemaInitial))
	if (!form.valid) return formError(form)
	const { username, password, cpassword } = form.data

	if (cpassword !== password)
		return formError(
			form,
			["password", "cpassword"],
			[" ", "The specified passwords do not match"]
		)

	if (await isAccountRegistered())
		return formError(
			form,
			["username"],
			["There's already an account registered"]
		)

	await equery(surql`UPDATE ONLY stuff:increment SET user = 0`)

	// This is the kind of stuff that always breaks due to never getting tested
	// Remember: untested === unworking
	const user = await createUser({
		username,
		email: "",
		hashedPassword: Bun.password.hashSync(password),
		permissionLevel: 5,
		currency: 0,
	})

	try {
		await requestRender("Avatar", user.number)
	} catch {}

	const session = await auth.createSession(user.id, {})
	const sessionCookie = auth.createSessionCookie(session.id)

	cookies.set(sessionCookie.name, sessionCookie.value, {
		path: ".",
		...sessionCookie.attributes,
	})

	redirect(302, "/home")
}
