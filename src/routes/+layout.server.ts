import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => ({
	bannerText: client.get("bannerText"),
	bannerColour: client.get("bannerColour"),
	bannerTextLight: client.get("bannerTextLight"), // truthy or falsy string
	stipendTime: Number((await client.get("stipendTime")) || 12),
}))
