import type { PageServerLoad, Actions } from "./$types"
import { auth } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

// Make sure a user is an administrator before loading the page.
export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.validateUser()
	if (!session.session || session.user.permissionLevel != "Administrator") throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))

	return {
		taxRate: client.get("taxRate"),
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
	}
}

export const actions: Actions = {
	updateBanner: async ({ request }) => {
		const data = await request.formData()
		const bannerText = data.get("bannerText")?.toString() || ""
		const bannerColour = data.get("bannerColour")?.toString()
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

	economy: async ({ request }) => {
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
		const username = data.get("username")?.toString().toLowerCase()
		const password = data.get("password")?.toString()

		if (!username || !password) return fail(400, { error: true, msg: "Missing fields" })

		try {
			await auth.updateKeyPassword("username", username, password)
		} catch (e) {
			return fail(400, { error: true, msg: "Invalid credentials" })
		}

		return {
			usersuccess: true,
			msg: "Password changed successfully!",
		}
	},
}
