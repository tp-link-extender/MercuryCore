import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { hostPort } from "#lib/server/db/places.ts"
import { parseMapLocation } from "#lib/server/loadscript.ts"
import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Selfhosted servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const port = await hostPort(ticket)
	if (port === undefined) error(400, "Invalid Server ticket")

	const mapLocation = parseMapLocation(url.searchParams.get("autopilot"))
	if (mapLocation === null) error(400, "Invalid map location")

	// const serverId = placeData.id.toString()
	const serverPresenceUrl = `http://${config.DomainInsecure}/game/serverpresence?ticket=${ticket}`

	const script = await buildNamedLoadscript("host", {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: mapLocation,
		SERVER_PORT: port,
		SERVER_PRESENCE_URL: serverPresenceUrl,
	})

	return new Response(await SignScript(script), {
		headers: {
			"Cache-Control": "no-store",
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
		},
	})
}
