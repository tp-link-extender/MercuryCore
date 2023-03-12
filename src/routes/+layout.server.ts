import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => ({
	// Some globals for pages, loaded from Redis

	banners: prisma.announcements.findMany({
		select: {
			body: true,
			bgColour: true,
			active: true,
			textLight: true,
		}
	})
	
}))
