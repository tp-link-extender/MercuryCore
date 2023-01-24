import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async () => {
	return {
		places: prisma.place.findMany({
			select: {
				name: true,
				slug: true,
				image: true,
			},
		}),
	}
}
