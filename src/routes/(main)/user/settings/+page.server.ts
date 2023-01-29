import type { Actions } from "./$types"
import { prisma } from "$lib/server/prisma"
import { fail } from "@sveltejs/kit"

export const actions: Actions = {
	profile: async ({ request, locals }) => {
		const data = await request.formData()
		const session = await locals.validateUser()
		const entries: any = Object.fromEntries(data.entries())

		if (session.user.bio == data.get("bio") && session.user.displayname == data.get("displayname")) return fail(400)
		// nothing changed

		if (!entries.displayName) return fail(400, { area: "displayName", msg: "Invalid displayname" })

		console.log(entries)
		await prisma.user.update({
			where: {
				id: session.user.userId,
			},
			data: {
				bio: entries.bio || "",
				displayname: entries.displayName,
			},
		})

		return {
			success: true,
			prev: entries
		}
	},

	password: async ({ request }) => {
		const data = await request.formData()
	},
}
