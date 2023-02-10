import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async () => {
	return {
		items: prisma.item.findMany({
			select: {
				name: true,
				id: true,
			},
		}),
	}
}
