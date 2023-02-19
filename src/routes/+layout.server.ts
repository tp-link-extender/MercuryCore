import { client } from "$lib/server/redis"
import { handleServerSession } from "@lucia-auth/sveltekit"

export const load = handleServerSession(async () => {
	await client.set("bannerText", "Mercury is in retrograde")
	await client.set("bannerColour", "lightblue")
	await client.set("bannerTextLight", "")


	return {
		bannerText: client.get("bannerText"),
		bannerColour: client.get("bannerColour"),
		bannerTextLight: client.get("bannerTextLight") // truthy or falsy string
	}
})
