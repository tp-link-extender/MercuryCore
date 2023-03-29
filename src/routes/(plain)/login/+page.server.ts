import { auth } from "$lib/server/lucia"
import { redirect, fail } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z.string().min(3).max(30),
	password: z.string().min(1).max(6969),
})

export const load = async (
	event
	// removing parentheses breaks things
) => ({
	form: await superValidate(event, schema),
})

export const actions = {
	default: async event => {
		const form = await superValidate(event, schema)
		const { username, password } = form.data

		if (form.valid)
			try {
				const user = await auth.useKey(
					"username",
					username.toLowerCase(),
					password
				)
				event.locals.setSession(await auth.createSession(user.userId))
			} catch {
				console.log(form)
				form.valid = false
				form.errors = {
					...form.errors,
					username: ["Incorrect username or password"],
					password: ["Incorrect username or password"],
				}
				console.log(form)
				return fail(400, { form })
			}
		else return fail(400, { form })

		throw redirect(302, "/home")
	},
}
