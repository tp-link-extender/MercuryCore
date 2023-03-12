import { prisma } from "$lib/server/prisma"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => ({
	banners: prisma.announcements.findMany({
		where: {
			active: true,
		},
		select: {
			body: true,
			bgColour: true,
			textLight: true,
		},
	}),
}))
