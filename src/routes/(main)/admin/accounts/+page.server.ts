import { auth, authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
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

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
	}
}

export const actions = {
	resetPassword: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals, 5)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "resetPassword", getClientAddress, 30)
		if (limit) return limit

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

		await prisma.auditLog.create({
			data: {
				action: "Account",
				note: `Change account password for ${username}`,
				user: {
					connect: {
						id: user.id,
					},
				},
			},
		})

		return message(form, "Password changed successfully!")
	},
}
