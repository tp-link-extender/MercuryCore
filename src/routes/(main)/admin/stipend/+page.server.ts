import { auth, authoriseAdmin } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)

	return {
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateStipend: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const limit = ratelimit("resetPassword", getClientAddress, 30)
		if (limit) return limit

		const data = await request.formData()
		const dailyStipend = Number(data.get("dailyStipend"))
		const stipendTime = Number(data.get("stipendTime"))
		console.log(stipendTime)

		if (!dailyStipend || !stipendTime) return fail(400, { error: true, msg: "Missing fields" })

		await client.set("dailyStipend", dailyStipend)
		await client.set("stipendTime", stipendTime)

		return {
			error: false,
			economysuccess: true,
			msg: "Economy updated successfully!",
		}
	},
}
