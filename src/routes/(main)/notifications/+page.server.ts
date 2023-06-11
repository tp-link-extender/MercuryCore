import { prisma } from "$lib/server/prisma"
import { authorise } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"

export const load = () =>
	prisma.notification.updateMany({
		data: {
			read: true,
		},
	})

export const actions = {
	default: async ({ locals, url }) => {
		const { user } = await authorise(locals)

		const id = url.searchParams.get("s")
		if (!id) return fail(400)

		try {
			await prisma.notification.updateMany({
				where: {
					id,
					receiverId: user.id,
				},
				data: {
					read: true,
				},
			})
		} catch (e: any) {
			return fail(400)
		}
	},
}
