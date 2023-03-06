import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	categories: prisma.forumCategory.findMany({
		select: {
			name: true,
			description: true,
			_count: {
				select: {
					posts: true,
				},
			},
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
						}
					}
				}
			},
		},
	}),
})
