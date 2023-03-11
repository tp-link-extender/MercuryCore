import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => ({
	// Some globals for pages, loaded from Redis
	bannerText: client.get("bannerText"),
	bannerColour: client.get("bannerColour"),
	bannerTextLight: client.get("bannerTextLight"), // truthy or falsy string
}))
