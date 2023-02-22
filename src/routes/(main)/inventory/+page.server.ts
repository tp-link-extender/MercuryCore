import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async ({ locals }) => {
	console.time("inventory")
	const session = await locals.validateUser()

	const user = await prisma.user.findUnique({
		where: {
			number: session.user?.number,
		},
		select: {
			itemsOwned: true,
		},
	})

	console.timeEnd("inventory")

	return {
		items: user?.itemsOwned,
	}
}
