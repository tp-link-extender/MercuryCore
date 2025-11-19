import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import placeQuery from "./place.surql"

type Place = {
	serverPort: number
	serverTicket: string
}

export async function GET({ params }) {
	const id = +params.id

	const [[place]] = await db.query<Place[][]>(placeQuery, {
		place: Record("place", id),
	})
	if (!place) error(404, "Place not found")

	// TODO: move to url without param
	const serverPresenceUrl = `https://${config.Domain}/game/serverpresence?ticket=${place.serverTicket}`

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		.replaceAll("_MAP_LOCATION", `"http://${config.Domain}/game/${id}"`)
		.replaceAll("_SERVER_PORT", place.serverPort.toString())
		.replaceAll("_SERVER_PRESENCE_URL", `"${serverPresenceUrl}"`)

	return new Response(await SignData(script))
}
