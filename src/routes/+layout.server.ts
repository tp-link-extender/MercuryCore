import type { LayoutServerLoad } from "./$types"
import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load: LayoutServerLoad = handleServerSession(async ({ url }) => ({
	// Some globals for pages, loaded from Redis
	bannerText: client.get("bannerText"),
	bannerColour: client.get("bannerColour"),
	bannerTextLight: client.get("bannerTextLight"), // truthy or falsy string
	stipendTime: Number((await client.get("stipendTime")) || 12),
	currentPath: url.pathname,
}))
