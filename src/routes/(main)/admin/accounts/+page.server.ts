import { auth, authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z
		.string()
		.min(3)
		.max(21)
		.regex(/^[A-Za-z0-9_]+$/),
	password: z.string().min(1).max(6969),
})

export async function load(event) {
	// Make sure a user is an administrator before loading the page.
	await authorise(event.locals, 5)

	return {
		form: superValidate(event, schema),
	}
}

export const actions = {
	resetPassword: async event => {
		await authorise(event.locals, 5)

		const limit = ratelimit("resetPassword", event.getClientAddress, 30)
		if (limit) return limit

		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const { username, password } = form.data

		try {
			await auth.updateKeyPassword(
				"username",
				username.toLowerCase(),
				password
			)
		} catch {
			return message(form, "Invalid credentials", {
				status: 400,
			})
		}

		return message(form, "Password changed successfully!")
	},
}
