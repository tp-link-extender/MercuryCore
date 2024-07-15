import { SignData } from "$lib/server/sign"
import { equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url }) {
	const ticket = url.searchParams.get("ticket")
	let mapLocation = url.searchParams.get("autopilot")

	if (!ticket) error(400, "Invalid Request")

	const [[placeData]] = await equery<{ serverPort: number }[][]>(
		surql`
			SELECT serverPort FROM place
			WHERE serverTicket = ${ticket}`
	)

	if (!placeData) error(400, "Invalid Server ticket")

	const port = placeData.serverPort
	// const serverId = placeData.id.toString()
	const serverPresenceUrl = `${process.env.DOMAIN}/game/serverpresence?ticket=${ticket}`

	if (mapLocation) {
		mapLocation = Buffer.from(mapLocation, "base64").toString()
		if (mapLocation.slice(-5) !== ".rbxl") mapLocation = null
		else if (mapLocation) mapLocation = `rbxasset://maps/${mapLocation}`
	}

	const script = (await Bun.file("corescripts/processed/host.lua").text())
		.replaceAll("_BASE_URL", `"${process.env.DOMAIN}"`)
		.replaceAll("_MAP_LOCATION_EXISTS", (!!mapLocation).toString())
		.replaceAll("_MAP_LOCATION", `"${mapLocation || ""}"`)
		.replaceAll("_SERVER_PORT", port.toString())
		.replaceAll("_SERVER_PRESENCE_URL", `"${serverPresenceUrl}"`)

	return new Response(await SignData(script))
}
