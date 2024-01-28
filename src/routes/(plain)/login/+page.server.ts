import { auth } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
import { Scrypt } from "oslo/password"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	password: z.string().min(1).max(6969),
})

export const load = async () => ({
	form: await superValidate(schema),
	users: (await squery<number>(surql`[count(SELECT * FROM user)]`)) > 0,
})

export const actions = {
	default: async ({ request, cookies }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { username, password } = form.data

		const user = await squery<{
			id: string
			username: string
			hashedPassword: string
		}>(
			surql`
				SELECT meta::id(id) AS id, username, hashedPassword
				FROM user
				WHERE string::lowercase(username) = string::lowercase($username)`,
			{ username }
		)

		// todo remove this on next database wipe
		if (user.hashedPassword.startsWith("s2:")) {
			user.hashedPassword = user.hashedPassword.slice(3)
			await query(
				surql`UPDATE $user SET hashedPassword = $hashedPassword`,
				{
					user: `user:${user.id}`,
					hashedPassword: user.hashedPassword,
				}
			)
		}

		console.log(user.hashedPassword)
		console.log(await new Scrypt().hash(password))

		// remove this statement and we'll end up like Mercury 1 💀
		if (
			!user ||
			!(await new Scrypt().verify(user.hashedPassword, password))
		)
			return formError(
				form,
				["username", "password"],
				[" ", "Incorrect username or password"]
			)

		const session = await auth.createSession(user.id, {})
		const sessionCookie = auth.createSessionCookie(session.id)

		cookies.set(sessionCookie.name, sessionCookie.value, {
			path: ".",
			...sessionCookie.attributes,
		})

		redirect(302, "/home")
	},
}
