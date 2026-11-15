import { error } from "@sveltejs/kit"
import { env } from "$env/dynamic/private"
import { bearerMatches } from "$lib/server/bearer"
import config from "$lib/server/config"
import idToPort from "$lib/server/idToPort"
import { buildLoadscript } from "$lib/server/loadscript"
import { SignScript } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types"
import placeQuery from "./place.surql"

interface Place {
	id: number
	serverPort: number
	serverTicket: string
}

export async function GET({ params, request }: RequestEvent) {
	if (config.Gameservers.Hosting === "Selfhosted")
		error(400, "Dedicated servers are not supported")

	if (!bearerMatches(request, env.GAMESERVER_KEY, "GAMESERVER_KEY"))
		error(403, "Unauthorised")

	const id = Number(params.id)

	const [[place]] = await db.query<Place[][]>(placeQuery, {
		place: Record("place", id),
	})
	if (!place) error(404, "Place not found")

	// TODO: move to url without param
	const serverPresenceUrl = `http://${config.DomainInsecure}/game/serverpresence?ticket=${place.serverTicket}`

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: `http://${config.DomainInsecure}/game/${id}?serverTicket=${encodeURIComponent(place.serverTicket)}`,
		SERVER_PORT: idToPort(id),
		SERVER_PRESENCE_URL: serverPresenceUrl,
	})

	return new Response(await SignScript(script))
}
