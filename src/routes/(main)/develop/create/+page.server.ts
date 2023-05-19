import { authorise } from "$lib/server/lucia"
// import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	type: z.enum(["2", "11", "12", "13"]),
	name: z.string().min(3).max(50),
	description: z.string().min(1).max(1000),
	price: z.number().int().min(0).max(999),
	asset: z.any(),
})

export const load = ({ request }) => ({
	form: superValidate(schema),
	assettype: new URL(request.url).searchParams.get("asset"),
})

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "assetCreation", getClientAddress, 30)
		if (limit) return limit

		// const { type, name, description, price, asset } = form.data
	},
}
