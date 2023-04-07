import { auth, authorise } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	dailyStipend: z.number().positive().max(100),
	stipendTime: z.number().min(1),
})

export async function load(event) {
	// Make sure a user is an administrator before loading the page.
	await authorise(event.locals, 5)

	return {
		form: superValidate(event, schema),
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateStipend: async event => {
		await authorise(event.locals, 5)

		const limit = ratelimit("resetPassword", event.getClientAddress, 30)
		if (limit) return limit

		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const { dailyStipend, stipendTime } = form.data

		console.log(stipendTime)

		await client.set("dailyStipend", dailyStipend)
		await client.set("stipendTime", stipendTime)

		return message(form, "Economy updated successfully!")
	},
}
