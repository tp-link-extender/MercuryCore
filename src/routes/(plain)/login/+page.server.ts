import { auth } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
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

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, cookies }) => {
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { username, password } = form.data

	const user = await squery<{
		id: string
		username: string
		hashedPassword: string
	}>(
		surql`
			SELECT meta::id(id) AS id, username, hashedPassword FROM user
			WHERE string::lowercase(username) = string::lowercase($username)`,
		{ username }
	)

	// remove this statement and we'll end up like Mercury 1 💀
	if (!user || !(await new Scrypt().verify(user.hashedPassword, password)))
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
}
