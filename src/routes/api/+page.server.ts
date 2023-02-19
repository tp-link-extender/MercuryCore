import type { PageServerLoad, Actions } from "./$types"
import { auth } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { prisma } from "$lib/server/prisma"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async () => {
	throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export const actions: Actions = {
	logout: async ({ locals }) => {
		const session = await locals.validate()
		if (!session) return fail(401)
		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.setSession(null) // remove cookie
		throw redirect(302, "/login")
	},
	stipend: async ({ locals }) => {
		const session = await locals.validateUser()
		if (!session) return fail(401)

		const user = await prisma.user.findUnique({
			where: {
				id: session.user.userId,
			},
			select: {
				currencyCollected: true,
			},
		})

		if (user) {
			const stipendTime = Number((await client.get("stipendTime")) || 12)
			if (user.currencyCollected.getTime() - (new Date().getTime() - 1000 * 3600 * stipendTime) > 0) return fail(400)

			const increment = Number((await client.get("dailyStipend")) || 10)

			await prisma.user.update({
				where: {
					id: session.user.userId,
				},
				data: {
					currencyCollected: new Date(),
					currency: {
						increment,
					},
				},
			})
		}
	},
}
