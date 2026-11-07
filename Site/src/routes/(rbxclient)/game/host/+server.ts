import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { buildLoadscript, parseMapLocation } from "$lib/server/loadscript"
import { SignScript } from "$lib/server/sign"
import { db } from "$lib/server/surreal"
import placeQuery from "./place.surql"

export async function GET({ url }) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Selfhosted servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const [[place]] = await db.query<{ serverPort: number }[][]>(placeQuery, {
		ticket,
	})
	if (!place) error(400, "Invalid Server ticket")

	const mapLocation = parseMapLocation(url.searchParams.get("autopilot"))
	if (mapLocation === null) error(400, "Invalid map location")

	const port = place.serverPort
	// const serverId = placeData.id.toString()
	const serverPresenceUrl = `http://${config.DomainInsecure}/game/serverpresence?ticket=${ticket}`

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: mapLocation,
		SERVER_PORT: Number(port),
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
