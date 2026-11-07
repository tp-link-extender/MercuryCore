import { timingSafeEqual } from "node:crypto"
import { error } from "@sveltejs/kit"
import { env } from "$env/dynamic/private"
import config from "$lib/server/config"
import idToPort from "$lib/server/idToPort"
import { SignScript } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types"
import placeQuery from "./place.surql"

type Place = {
	id: number
	serverPort: number
	serverTicket: string
}

function constantTimeEqual(a: string, b: string): boolean {
	const ah = Buffer.from(a)
	const bh = Buffer.from(b)
	if (ah.byteLength !== bh.byteLength) return false
	return timingSafeEqual(ah, bh)
}

export async function GET({ params, request }: RequestEvent) {
	if (config.Gameservers.Hosting === "Selfhosted")
		error(400, "Dedicated servers are not supported")

	const gameserverKey = env.GAMESERVER_KEY
	const auth = request.headers.get("Authorization")
	const bearer = auth?.startsWith("Bearer ") ? auth.slice(7) : null
	if (!gameserverKey || !bearer || !constantTimeEqual(bearer, gameserverKey))
		error(403, "Unauthorised")

	const id = Number(params.id)

	const [[place]] = await db.query<Place[][]>(placeQuery, {
		place: Record("place", id),
	})
	if (!place) error(404, "Place not found")

	// TODO: move to url without param
	const serverPresenceUrl = `http://${config.DomainInsecure}/game/serverpresence?ticket=${place.serverTicket}`

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${config.DomainInsecure}"`)
		.replaceAll(
			"_MAP_LOCATION",
			`"http://${config.DomainInsecure}/game/${id}?serverTicket=${encodeURIComponent(place.serverTicket)}"`
		)
		.replaceAll("_SERVER_PORT", idToPort(id).toString())
		.replaceAll("_SERVER_PRESENCE_URL", `"${serverPresenceUrl}"`)

	return new Response(await SignScript(script))
}
