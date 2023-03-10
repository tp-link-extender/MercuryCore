import { auth, authoriseAdmin } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)

	return {
		taxRate: client.get("taxRate"),
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateBanner: async ({ request, locals }) => {
		await authoriseAdmin(locals)

		const data = await request.formData()
		const bannerText = data.get("bannerText") as string
		const bannerColour = data.get("bannerColour") as string
		const bannerTextLight = data.get("bannerTextLight")

		if (!bannerColour) return fail(400, { error: true, msg: "Missing fields" })

		await client.set("bannerText", bannerText)
		await client.set("bannerColour", bannerColour)
		await client.set("bannerTextLight", bannerTextLight ? "true" : "")

		return {
			bannersuccess: true,
			msg: "Banner updated successfully!",
		}
	},

	economy: async ({ request, locals }) => {
		await authoriseAdmin(locals)

		const data = await request.formData()
		const taxRate = Number(data.get("taxRate"))
		const dailyStipend = Number(data.get("dailyStipend"))
		const stipendTime = Number(data.get("stipendTime"))
		console.log(stipendTime)

		if (!taxRate || !dailyStipend || !stipendTime) return fail(400, { error: true, msg: "Missing fields" })

		await client.set("taxRate", taxRate)
		await client.set("dailyStipend", dailyStipend)
		await client.set("stipendTime", stipendTime)

		return {
			economysuccess: true,
			msg: "Economy updated successfully!",
		}
	},

	user: async ({ request }) => {
		const data = await request.formData()
		const username = (data.get("username") as string).trim()
		const password = (data.get("password") as string).trim()

		if (!username || !password) return fail(400, { error: true, msg: "Missing fields" })

		try {
			await auth.updateKeyPassword("username", username, password)
		} catch {
			return fail(400, { error: true, msg: "Invalid credentials" })
		}

		return {
			usersuccess: true,
			msg: "Password changed successfully!",
		}
	},
}
