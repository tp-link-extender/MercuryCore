import type { PageServerLoad } from "./$types"
import { prisma, findPlaces } from "$lib/server/prisma"

export const load: PageServerLoad = async () => {
	return {
		transactions: prisma.transaction.findMany({
			select: {
				id: true,
				amountSent: true,
				taxRate: true,
				sender: {
					select: {
						displayname: true,
					},
				},
				receiver: {
					select: {
						displayname: true,
					},
				},
			},
			orderBy: {
				time: "desc",
			},
		}),
	}
}
