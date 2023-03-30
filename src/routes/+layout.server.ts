import { prisma } from "$lib/server/prisma"

export const load = async ({ locals }) => ({
	banners: prisma.announcements.findMany({
		where: {
			active: true,
		},
		select: {
			body: true,
			bgColour: true,
		},
	}),
	user: (await locals.validateUser()).user,
})
