import { prisma } from "$lib/server/prisma"

export const load = async ({ locals }) => ({
	banners: prisma.announcements.findMany({
		where: {
			active: true,
		},
		select: {
			id: true,
			body: true,
			bgColour: true,
			textLight: true,
		},
	}),
	user: (await locals.validateUser()).user,
})
