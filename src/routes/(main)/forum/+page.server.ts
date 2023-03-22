import { prisma } from "$lib/server/prisma"

export const load = async () => ({
	categories: prisma.forumCategory.findMany({
		include: {
			_count: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 1,
				include: {
					author: true,
					content: {
						orderBy: {
							updated: "desc",
						},
						take: 1,
					},
				},
			},
		},
	}),
})
