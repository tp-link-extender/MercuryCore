import { auth } from "$lib/server/lucia"
import { query, squery, mquery, surql, findWhere } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import requestRender, { RenderType } from "$lib/server/requestRender"
import { Scrypt } from "oslo/password"

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
	const q = await mquery<
		{
			number: number
			id: string
		}[]
	>(
		// Assign $number to a variable, otherwise when it's returned it will increment the number by 2 instead of 1 (?????????)
		surql`
			LET $number = (UPDATE ONLY stuff:increment SET user += 1).user;
			UPDATE (CREATE user CONTENT $user)[0] MERGE {
				theme: "standard",
				created: time::now(),
				currencyCollected: time::now(),
				bio: [],
				bodyColours: {
					Head: 24,
					Torso: 23,
					LeftArm: 24,
					RightArm: 24,
					LeftLeg: 119,
					RightLeg: 119,
				},
				status: <future> {
					(IF (SELECT 1 FROM ->playing
						WHERE valid AND ping > time::now() - 35s
					)[0] THEN
						"Playing"
					ELSE IF lastOnline > time::now() - 35s THEN
						"Online"
					ELSE
						"Offline"
					END)
				},
				number: $number,
			};
			LET $u = (SELECT number, id FROM user
				WHERE username = $user.username)[0];
			# Return some user data
			{
				id: meta::id($u.id),
				number: $number,
			};
			${
				keyUsed
					? surql`
						UPDATE ONLY $key SET usesLeft -= 1;
						RELATE $u->used->$key`
					: ""
			}`,
		{ user, key: `regKey:⟨${keyUsed}⟩` }
	)

	return q[3]
}

export const load = async () => ({
	form: await superValidate(zod(schema)),
	users: (await squery<number>(surql`[count(SELECT 1 FROM user)]`)) > 0,
})

export const actions = {
	register: async ({ request, cookies }) => {
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

		const userCheck = await findWhere("user", surql`username = $username`, {
			username,
		})

		if (userCheck)
			return formError(
				form,
				["username"],
				["This username is already in use"]
			)

		const emailCheck = await findWhere("user", surql`email = $email`, {
			email,
		})

		if (emailCheck)
			return formError(form, ["email"], ["This email is already in use"])

		const regkeyCheck = await squery<{
			usesLeft: number
		}>(surql`SELECT usesLeft FROM $regkey`, {
			regkey: `regKey:⟨${regkey}⟩`,
		})

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
	},
	initialAccount: async ({ request, cookies }) => {
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

		if ((await squery<number>(surql`[count(SELECT * FROM user)]`)) > 0)
			return formError(
				form,
				["username"],
				["There's already an account registered"]
			)

		await query(surql`UPDATE ONLY stuff:increment SET user = 0`)

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
	},
}
