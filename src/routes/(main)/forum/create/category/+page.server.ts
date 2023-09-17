import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import surreal from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { redirect } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().max(50),
	description: z.string().max(300),
})

export async function load({ locals }) {
	await authorise(locals, 5)
	return {
		form: superValidate(schema),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "forumCategory", getClientAddress, 30)
		if (limit) return limit

		const { name, description } = form.data

		await Promise.all([
			prisma.forumCategory.create({
				data: {
					name,
					description,
				},
			}),
			surreal.create(
				`forumCategory:${name}`,
				{
					name,
					description,
				}
			),
		])

		throw redirect(302, `/forum/${name}`)
	},
}