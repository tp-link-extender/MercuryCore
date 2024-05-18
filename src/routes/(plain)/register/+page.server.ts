import { auth } from "$lib/server/lucia"
import { findWhere, surrealql, equery, RecordId } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import requestRender, { RenderType } from "$lib/server/requestRender"
import { Scrypt } from "oslo/password"
import createUserQuery from "./createUser.surql"

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

async function createUser(
	user: {
		username: string
		email: string
		hashedPassword: string
		permissionLevel: number
		currency: number
	},
	keyUsed?: string
) {
	let query = createUserQuery
	let key: RecordId | undefined
	if (keyUsed) {
		query += `
			UPDATE ONLY $key SET usesLeft -= 1;
			RELATE $u->used->$key`
		key = new RecordId("regKey", keyUsed)
	}

	const q = await equery<{ number: number; id: string }[]>(query, {
		user,
		key,
	})

	return q[3]
}

async function isAccountRegistered() {
	const [userCount] = await equery<number[]>(
		surrealql`count(SELECT 1 FROM user)`
	)

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

	let { username, email, password, cpassword, regkey } = form.data

	email = email.toLowerCase()
	regkey = regkey.split("-")[1]

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
		surrealql`SELECT usesLeft FROM ${new RecordId("regKey", regkey)}`
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
			hashedPassword: await new Scrypt().hash(password),
			permissionLevel: 1,
			currency: 0,
		},
		regkey
	)

	try {
		await requestRender(RenderType.Avatar, user.number)
	} catch {}

	const session = await auth.createSession(user.id, {})
	const sessionCookie = auth.createSessionCookie(session.id)

	cookies.set(sessionCookie.name, sessionCookie.value, {
		path: ".",
		...sessionCookie.attributes,
	})

	redirect(302, "/home")
}
actions.initialAccount = async ({ request, cookies }) => {
	// This is the initial account creation, which is only allowed if there are no existing users.

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

	await equery(surrealql`UPDATE ONLY stuff:increment SET user = 0`)

	// This is the kind of stuff that always breaks due to never getting tested
	// Remember: untested === unworking
	const user = await createUser({
		username,
		email: "",
		hashedPassword: await new Scrypt().hash(password),
		permissionLevel: 5,
		currency: 0,
	})

	try {
		await requestRender(RenderType.Avatar, user.number)
	} catch {}

	const session = await auth.createSession(user.id, {})
	const sessionCookie = auth.createSessionCookie(session.id)

	cookies.set(sessionCookie.name, sessionCookie.value, {
		path: ".",
		...sessionCookie.attributes,
	})

	redirect(302, "/home")
}
