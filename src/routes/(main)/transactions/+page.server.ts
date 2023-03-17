import { prisma } from "$lib/server/prisma"

export const load = async () => ({
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
					username: true,
				},
			},
			receiver: {
				select: {
					image: true,
					number: true,
					username: true,
				},
			},
		},
		orderBy: {
			time: "desc",
		},
	}),
})
