import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import { squery, surql } from "$lib/server/surreal"
import fs from "node:fs"

export async function GET({ url }) {
	const ticket = url.searchParams.get("ticket")
	let mapLocation = url.searchParams.get("autopilot")

	if (!ticket) error(400, "Invalid Request")

	const placeData = await squery<{ serverPort: number }>(
		surql`
			SELECT serverPort FROM place
			WHERE serverTicket = $ticket`,
		{ ticket }
	)

	if (!placeData) error(400, "Invalid Server Ticket")

	const port = placeData.serverPort
	// const serverId = placeData.id.toString()
	const serverPresenceUrl = `${process.env.SERVER_PRESENCE}/game/serverpresence?ticket=${ticket}`

	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) !== ".rbxl") mapLocation = null
		else if (mapLocation != null)
			mapLocation = `rbxasset://maps/${mapLocation}`
	}

	return new Response(
		SignData(
			fs
				.readFileSync("corescripts/processed/host.lua", "utf-8")
				.replaceAll("_BASE_URL", `"${process.env.RCC_ORIGIN}"`)
				.replaceAll("_MAP_LOCATION_EXISTS", (!!mapLocation).toString())
				.replaceAll("_MAP_LOCATION", `"${mapLocation || ""}"`)
				.replaceAll("_SERVER_PORT", port.toString())
				.replaceAll("_SERVER_PRESENCE_URL", `"${serverPresenceUrl}"`)
		)
	)
}
