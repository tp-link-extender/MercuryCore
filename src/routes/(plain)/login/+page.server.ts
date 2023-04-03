import { auth } from "$lib/server/lucia"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
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

export const load = async (
	event
	// removing parentheses breaks things
) => ({
	form: superValidate(event, schema),
})

export const actions = {
	default: async event => {
		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const { username, password } = form.data

		try {
			const user = await auth.useKey(
				"username",
				username.toLowerCase(),
				password
			)
			event.locals.setSession(await auth.createSession(user.userId))
		} catch {
			return formError(
				form,
				["username", "password"],
				[
					"Incorrect username or password",
					"Incorrect username or password",
				]
			)
		}

		throw redirect(302, "/home")
	},
}
