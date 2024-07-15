import formError from "$lib/server/formError"
import { auth } from "$lib/server/lucia"
import { equery, surql } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
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

export async function load() {
	const [users] = await equery<number[]>(surql`count(SELECT 1 FROM user)`)

	return {
		form: await superValidate(zod(schema)),
		users: users > 0,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, cookies }) => {
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { username, password } = form.data

	const [[user]] = await equery<
		{
			id: string
			username: string
			hashedPassword: string
		}[][]
	>(
		surql`
			SELECT meta::id(id) AS id, username, hashedPassword FROM user
			WHERE string::lowercase(username) = string::lowercase(${username})`
	)

	// remove this statement and we'll end up like Mercury 1 💀
	if (!user || !Bun.password.verifySync(password, user.hashedPassword))
		return formError(
			form,
			["username", "password"],
			[" ", "Incorrect username or password"] // Don't give any extra information which may be useful to attackers
		)

	const session = await auth.createSession(user.id, {})
	const sessionCookie = auth.createSessionCookie(session.id)

	cookies.set(sessionCookie.name, sessionCookie.value, {
		path: ".",
		...sessionCookie.attributes,
	})

	redirect(302, "/home")
}
