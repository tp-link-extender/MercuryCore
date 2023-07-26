import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import { prisma } from "$lib/server/prisma"
import fs from "fs"

export async function GET({ url }) {
	const ticket = url.searchParams.get("ticket")
	let mapLocation = url.searchParams.get("autopilot")

	if (!ticket) throw error(400, "Invalid Request")

	const placeData = await prisma.place.findUnique({
		where: { serverTicket: ticket },
	})

	let port = 53640
	let baseUrl = "..."
	// let serverId = "..."
	let serverPresenceUrl = "..."

	if (placeData) {
		port = placeData.serverPort
		baseUrl = "http://banland.xyz"
		// serverId = placeData.id.toString()
		serverPresenceUrl = `${baseUrl}/game/serverpresence?ticket=${ticket}`
	}

	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) != ".rbxl") mapLocation = null

		if (mapLocation != null) mapLocation = `rbxasset://maps/${mapLocation}`
	}

	return new Response(
		SignData(
			fs
				.readFileSync(`corescripts/processed/host.lua`, "utf-8")
				.replaceAll("_BASE_URL", baseUrl)
				.replaceAll("_MAP_LOCATION_EXISTS", (!!mapLocation).toString())
				.replaceAll("_MAP_LOCATION", mapLocation || "null")
				.replaceAll("_SERVER_PORT", port.toString())
				.replaceAll("_SERVER_PRESENCE_URL", serverPresenceUrl),
		),
	)
}
