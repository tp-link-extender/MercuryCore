import { error } from "@sveltejs/kit"
import { bearerMatches } from "#lib/server/bearer.ts"
import config from "#lib/server/config.ts"
import { serveTicket } from "#lib/server/db/places.ts"
import idToPort from "#lib/server/idToPort.ts"
import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"
import { ORBITER_KEY } from "$app/env/private"
import type { RequestEvent } from "./$types"

export async function GET({ params, request }: RequestEvent) {
	if (config.Gameservers.Hosting === "Selfhosted")
		error(400, "Dedicated servers are not supported")

	if (!bearerMatches(request, ORBITER_KEY, "ORBITER_KEY"))
		error(403, "Unauthorised")

	const id = Number(params.id)

	const serverTicket = await serveTicket(id)
	if (serverTicket === undefined) error(404, "Place not found")

	// TODO: move to url without param
	const serverPresenceUrl = `http://${config.DomainInsecure}/game/serverpresence?ticket=${serverTicket}`

	const script = await buildNamedLoadscript("host", {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: `http://${config.DomainInsecure}/game/${id}?serverTicket=${encodeURIComponent(serverTicket)}`,
		SERVER_PORT: idToPort(id),
		SERVER_PRESENCE_URL: serverPresenceUrl,
	})

	return new Response(await SignScript(script))
}
