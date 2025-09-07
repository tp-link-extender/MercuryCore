import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
import placeQuery from "./place.surql"

export async function GET({ url }) {
	const ticket = url.searchParams.get("ticket")
	let mapLocation = url.searchParams.get("autopilot")

	if (!ticket) error(400, "Invalid Request")

	const [[place]] = await db.query<{ serverPort: number }[][]>(placeQuery, {
		ticket,
	})
	if (!place) error(400, "Invalid Server ticket")

	const port = place.serverPort
	// const serverId = placeData.id.toString()
	const serverPresenceUrl = `${config.Domain}/game/serverpresence?ticket=${ticket}`

	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) !== ".rbxl") mapLocation = null
		else if (mapLocation) mapLocation = `rbxasset://maps/${mapLocation}`
	}

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		.replaceAll("_MAP_LOCATION_EXISTS", (!!mapLocation).toString())
		.replaceAll("_MAP_LOCATION", mapLocation || "")
		.replaceAll("_SERVER_PORT", port.toString())
		.replaceAll("_SERVER_PRESENCE_URL", serverPresenceUrl)

	return new Response(script)
}
