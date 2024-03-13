import { auth } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import { user } from "$lib/server/orm"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
import { Scrypt } from "oslo/password"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"

const schema = z.object({
	username: z
		.string()
		.min(3, { message: "Your username must be at least 3 characters long" })
		.max(21, {
			message: "Your username must be less than 21 characters long",
		})
		.regex(/^[A-Za-z0-9_]*$/, {
			message:
				"Your username can only contain the characters A-Z, a-z, 0-9, _",
		}),
	password: z
		.string()
		.min(1, { message: "Your password must be at least 1 character long" })
		.max(6969, {
			message: "Your password must be less than 6969 characters long",
		}),
})

export const load = async () => ({
	form: await superValidate(zod(schema)),
	users: (await squery<number>(surql`[count(SELECT 1 FROM user)]`)) > 0,
})

export const actions = {
	default: async ({ request, cookies }) => {
		const form = await superValidate(request, zod(schema))
		if (!form.valid) return formError(form)

		const { username, password } = form.data

		// const foundUser = await squery<{
		// 	id: string
		// 	username: string
		// 	hashedPassword: string
		// }>(
		// 	surql`
		// 		SELECT meta::id(id) AS id, username, hashedPassword FROM user
		// 		WHERE string::lowercase(username) = string::lowercase($username)`,
		// 	{ username }
		// )
		const foundUser = await user
			.where(
				["string::lowercase(username) = string::lowercase($username)"],
				{ username }
			)
			.select1("metaId", "username", "hashedPassword")
		const foundUsers = await user
			.where(
				["string::lowercase(username) = string::lowercase($username)"],
				{ username }
			)
			.select("metaId", "username", "hashedPassword")

		foundUser.id
		foundUsers[0].id

		// remove this statement and we'll end up like Mercury 1 💀
		if (
			!foundUser ||
			!(await new Scrypt().verify(foundUser.hashedPassword, password))
		)
			return formError(
				form,
				["username", "password"],
				[" ", "Incorrect username or password"]
			)

		const session = await auth.createSession(foundUser.id, {})
		const sessionCookie = auth.createSessionCookie(session.id)

		cookies.set(sessionCookie.name, sessionCookie.value, {
			path: ".",
			...sessionCookie.attributes,
		})

		redirect(302, "/home")
	},
}
