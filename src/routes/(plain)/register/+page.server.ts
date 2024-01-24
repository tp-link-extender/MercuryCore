import { auth } from "$lib/server/lucia"
import surreal, { query, squery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { redirect, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import requestRender from "$lib/server/requestRender"
import type { GlobalDatabaseUserAttributes } from "lucia"

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

export const load = async () => ({
	form: await superValidate(schema),
	users: (await squery<number>(surql`[count(SELECT * FROM user)]`)) > 0,
})

export const actions = {
	register: async ({ request, locals }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		let { username, email, password, cpassword, regkey } = form.data

		email = email.toLowerCase() || ""
		regkey = regkey.split("-")[1] || ""

		if (cpassword !== password)
			return formError(
				form,
				["password", "cpassword"],
				[" ", "The specified passwords do not match"]
			)

		try {
			if (
				await squery(
					surql`SELECT * FROM user WHERE username = $username`,
					{ username }
				)
			)
				return formError(
					form,
					["username"],
					["This username is already in use"]
				)

			if (
				await squery(surql`SELECT * FROM user WHERE email = $email`, {
					email,
				})
			)
				return formError(
					form,
					["email"],
					["This email is already in use"]
				)

			const regkeyCheck = (
				(await surreal.select(`regKey:⟨${regkey}⟩`)) as {
					usesLeft: number
				}[]
			)[0]

			if (!regkeyCheck)
				return formError(
					form,
					["regkey"],
					["Registration key is invalid"]
				)
			if (regkeyCheck.usesLeft < 1)
				return formError(
					form,
					["regkey"],
					["This registration key has ran out of uses"]
				)

			const { userId } = await auth.createUser({
				key: {
					providerId: "username",
					providerUserId: username.toLowerCase(),
					password,
				},
				attributes: {
					username,
					email,
					permissionLevel: 1,
					currency: 0,
				} as GlobalDatabaseUserAttributes,
			})

			const { number } = await squery<{
				number: number
			}>(
				surql`
					SELECT * FROM $user;
					RELATE $user->used->$key;
					UPDATE $key SET usesLeft -= 1`,
				{
					user: `user:${userId}`,
					key: `regKey:⟨${regkey}⟩`,
				}
			)

			try {
				await requestRender("Avatar", number)
			} catch {}

			locals.auth.setSession(
				await auth.createSession({
					userId,
					attributes: {},
				})
			)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_DUPLICATE_PROVIDER_ID")
				return formError(
					form,
					["username"],
					["This username is already in use"]
				)

			console.error("Registration error:", error)
			return fail(500) // idk
		}

		redirect(302, "/home")
	},
	initialAccount: async ({ request, locals }) => {
		// This is the initial account creation, which is
		// only allowed if there are no existing users.

		const form = await superValidate(request, schemaInitial)
		if (!form.valid) return formError(form)

		const { username, password, cpassword } = form.data

		if (cpassword !== password)
			return formError(
				form,
				["password", "cpassword"],
				[" ", "The specified passwords do not match"]
			)

		try {
			if ((await squery<number>(surql`[count(SELECT * FROM user)]`)) > 0)
				return formError(
					form,
					["username"],
					["There's already an account registered"]
				)

			await query(surql`UPDATE ONLY stuff:increment SET user = 0`)

			const user = await auth.createUser({
				key: {
					providerId: "username",
					providerUserId: username.toLowerCase(),
					password,
				},
				attributes: {
					username,
					email: "",
					permissionLevel: 5,
					currency: 999999,
				} as GlobalDatabaseUserAttributes,
			})

			locals.auth.setSession(
				await auth.createSession({
					userId: user.id,
					attributes: {},
				})
			)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_DUPLICATE_PROVIDER_ID")
				return formError(
					form,
					["username"],
					["This username is already in use"]
				)

			console.error("Registration error:", error)
			return fail(500) // idk
		}

		redirect(302, "/home")
	},
}
