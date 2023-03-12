import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => ({
	// Some globals for pages, loaded from Redis

	banners: prisma.announcements.findMany({
		where: {
			active: true,
		},
		select: {
			body: true,
			bgColour: true,
			textLight: true,
		}
	})
	
}))
