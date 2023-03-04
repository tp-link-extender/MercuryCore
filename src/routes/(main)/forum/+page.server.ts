import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	categories: prisma.forumCategory.findMany({
		select: {
			name: true,
			description: true,
		},
	}),
})
