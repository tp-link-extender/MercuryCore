import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import placeQuery from "./place.surql"

// whatever
const idToPort = (id: number) => 10000 + (id % 50000)

type Place = {
	id: number
	serverPort: number
	serverTicket: string
}

export async function GET({ params }) {
	if (config.Gameservers.Hosting === "Selfhosted")
		error(400, "Dedicated servers are not supported")

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
		.replaceAll("_SERVER_PORT", idToPort(id).toString())
		.replaceAll("_SERVER_PRESENCE_URL", `"${serverPresenceUrl}"`)

	return new Response(await SignData(script))
}
