import { redirect } from "@sveltejs/kit"
import { zod4 } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod/v4"
import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db } from "$lib/server/surreal"
import createQuery from "./create.surql"

const schema = z.object({
	name: z.string().max(50),
	description: z.string().max(300),
})

export async function load({ locals }) {
	exclude("Forum")
	await authorise(locals, 5)
	return { form: await superValidate(zod4(schema)) }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, getClientAddress }) => {
	exclude("Forum")
	await authorise(locals, 5)
	const form = await superValidate(request, zod4(schema))
	if (!form.valid) return formError(form)

	const { description, name } = form.data
	// Conflicts with /forum/create
	if (name.toLowerCase() === "create")
		return formError(form, ["name"], ["Can't park there mate"])

	const limit = ratelimit(form, "forumCategory", getClientAddress, 30)
	if (limit) return limit

	await db.query(createQuery, { description, name })

	redirect(302, `/forum/${name}`)
}
