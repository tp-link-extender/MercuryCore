// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import type { PageServerLoad, Actions } from "./$types"
import { auth, authorise, authoriseUser } from "$lib/server/lucia"
import { client } from "$lib/server/redis"
import { prisma } from "$lib/server/prisma"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async () => {
	throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export const actions: Actions = {
	logout: async ({ locals }) => {
		const session = await authorise(locals.validate)

		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.setSession(null) // remove cookie
		throw redirect(302, "/login")
	},

	stipend: async ({ locals }) => {
		const user = (await authoriseUser(locals.validateUser)).user

		const userExists = await prisma.user.findUnique({
			where: {
				id: user?.userId,
			},
			select: {
				currencyCollected: true,
			},
		})

		if (userExists) {
			const stipendTime = Number((await client.get("stipendTime")) || 12)
			if (userExists.currencyCollected.getTime() - (new Date().getTime() - 1000 * 3600 * stipendTime) > 0) return fail(400)

			const increment = Number((await client.get("dailyStipend")) || 10)

			await prisma.user.update({
				where: {
					id: user?.userId,
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
