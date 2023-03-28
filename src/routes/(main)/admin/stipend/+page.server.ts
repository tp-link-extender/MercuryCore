import { auth, authorise } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 5)

	return {
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateStipend: async ({ request, locals, getClientAddress }) => {
		await authorise(locals, 5)

		const limit = ratelimit("resetPassword", getClientAddress, 30)
		if (limit) return limit

		const data = await formData(request)
		const dailyStipend = Number(data.dailyStipend)
		const stipendTime = Number(data.stipendTime)
		console.log(stipendTime)

		if (!dailyStipend || !stipendTime)
			return fail(400, { error: true, msg: "Missing fields" })

		await client.set("dailyStipend", dailyStipend)
		await client.set("stipendTime", stipendTime)

		return {
			error: false,
			economysuccess: true,
			msg: "Economy updated successfully!",
		}
	},
}
