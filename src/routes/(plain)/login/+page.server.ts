import { auth } from "$lib/server/lucia"
import { query, surql } from "$lib/server/surreal"
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

export const load = async () => ({
	form: await superValidate(schema),
	users:
		((await query(surql`count(SELECT * FROM user)`)) as unknown as number) >
		0,
})

export const actions = {
	default: async ({ request, locals }) => {
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { username, password } = form.data

		try {
			const user = await auth.useKey(
				"username",
				username.toLowerCase(),
				password,
			)
			locals.auth.setSession(
				await auth.createSession({
					userId: user.userId,
					attributes: {},
				}),
			)
		} catch {
			return formError(
				form,
				["username", "password"],
				[" ", "Incorrect username or password"],
			)
		}

		redirect(302, "/home")
	},
}
