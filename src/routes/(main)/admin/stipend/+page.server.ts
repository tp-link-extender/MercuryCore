import { authorise } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	dailyStipend: z.number().int().positive().max(100),
	stipendTime: z.number().min(1),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateStipend: async ({ request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "resetPassword", getClientAddress, 30)
		if (limit) return limit

		const { dailyStipend, stipendTime } = form.data

		console.log(stipendTime)

		await client.set("dailyStipend", dailyStipend)
		await client.set("stipendTime", stipendTime)

		return message(form, "Economy updated successfully!")
	},
}
