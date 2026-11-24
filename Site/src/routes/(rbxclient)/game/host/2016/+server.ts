import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { hostPlace } from "#lib/server/db/places.ts"
import { luaId } from "#lib/server/loadscript.ts"
import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Selfhosted servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const place = await hostPlace(ticket)
	if (!place) error(400, "Invalid Server ticket")

	const port = place.serverPort
	const serverId = place.id

	console.log(`Hosting 2016 server ${serverId} on port ${port}`)

	// Autopilot map substitution is disabled for now. If it is re-enabled, pass parseMapLocation(url.searchParams.get("autopilot")) as MAP_LOCATION.
	const script = await buildNamedLoadscript("host2016", {
		BASE_URL: config.Domain,
		MAP_LOCATION: "rbxasset://mbdtf.rbxl", // TODO: remove hardcoded map
		PLACE_ID: luaId(serverId),
		SERVER_PORT: port,
	})

	return new Response(await SignScript(script), {
		headers: {
			"Cache-Control": "no-store",
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
		},
	})
}
