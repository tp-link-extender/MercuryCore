import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { SignScript } from "$lib/server/sign"
import { db } from "$lib/server/surreal"
import placeQuery from "../place.surql"

export async function GET({ params, url }) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Dedicated servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const [[place]] = await db.query<{ serverPort: number }[][]>(placeQuery, {
		ticket,
	})
	if (!place) error(400, "Invalid Server ticket")

	const port = place.serverPort
	// const serverId = placeData.id.toString()

	let mapLocation = url.searchParams.get("autopilot")
	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) !== ".rbxl") mapLocation = null
		else if (mapLocation) mapLocation = `rbxasset://maps/${mapLocation}`
	}

	const scriptFile = Bun.file("../data/server/loadscripts/host2016.lua")
	const script = (await scriptFile.text())
		// .replaceAll("_PLACE_ID", "0")
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		// .replaceAll("_MAP_LOCATION", `"${mapLocation || ""}"`)
		.replaceAll("_MAP_LOCATION", `"rbxasset://mbdtf.rbxl"`) // TODO: remove again
		.replaceAll("_SERVER_PORT", port.toString())

	return new Response(await SignScript(script))
}
