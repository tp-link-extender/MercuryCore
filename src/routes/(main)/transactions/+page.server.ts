import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	transactions: prisma.transaction.findMany({
		select: {
			id: true,
			time: true,
			amountSent: true,
			taxRate: true,
			note: true,
			link: true,
			sender: {
				select: {
					image: true,
					number: true,
					displayname: true,
				},
			},
			receiver: {
				select: {
					image: true,
					number: true,
					displayname: true,
				},
			},
		},
		orderBy: {
			time: "desc",
		},
	}),
})
