import { prisma } from "$lib/server/prisma"

export const load = () => ({
	categories: prisma.forumCategory.findMany({
		include: {
			_count: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 1,
				select: {
					id: true,
					title: true,
					author: {
						select: {
							username: true,
							number: true,
						},
					},
					content: {
						orderBy: {
							updated: "desc",
						},
						select: {
							text: true,
						},
						take: 1,
					},
				},
			},
		},
	}),
})
