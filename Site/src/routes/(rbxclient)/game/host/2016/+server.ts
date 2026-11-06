import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { buildLoadscript, luaRaw } from "$lib/server/loadscript"
import { toRawId } from "$lib/server/recordId"
import { SignScript } from "$lib/server/sign"
import { db } from "$lib/server/surreal"
import placeQuery from "../place.surql"

export async function GET({ url }) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Dedicated servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const [[place]] = await db.query<{ serverPort: number, id: number }[][]>(placeQuery, {
		ticket,
	})
	if (!place) error(400, "Invalid Server ticket")

	const port = place.serverPort
	const serverId = place.id

	console.log(`Hosting 2016 server ${serverId} on port ${port}`)

	let mapLocation = url.searchParams.get("autopilot")
	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) !== ".rbxl") mapLocation = null
		else if (mapLocation) mapLocation = `rbxasset://maps/${mapLocation}`
	}

	const scriptFile = Bun.file("../data/server/loadscripts/host2016.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		PLACE_ID: luaRaw(toRawId(serverId)),
		BASE_URL: config.Domain,
		MAP_LOCATION: "rbxasset://mbdtf.rbxl", // TODO: remove hardcoded map
		SERVER_PORT: Number(port),
	})

	return new Response(await SignScript(script), {
		headers: {
			"Cache-Control": "no-store",
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
		},
	})
}
