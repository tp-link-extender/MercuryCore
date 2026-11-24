import { error } from "@sveltejs/kit"
import { Place } from "economy/types"
import { bearerMatches } from "#lib/server/bearer.ts"
import constantTimeEqual from "#lib/server/constantTimeEqual.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import { GAMESERVER_KEY } from "$app/env/private"
import type { RequestEvent } from "./$types"

const placeAccessQuery = `
	SELECT
		privateServer,
		privateTicket,
		serverTicket
	FROM $place;
`

export async function GET({
	fetch: f,
	locals,
	params,
	request,
	url,
}: RequestEvent) {
	const id = Number(params.id)

	const [[place]] = await dbQuery<
		{
			privateServer: boolean
			privateTicket: string
			serverTicket: string
		}[][]
	>(placeAccessQuery, { place: Record("place", id) })
	if (!place) error(404, "Not Found")

	const ticket = url.searchParams.get("serverTicket")
	const privateTicket = url.searchParams.get("privateTicket")

	let authorised =
		bearerMatches(request, GAMESERVER_KEY, "GAMESERVER_KEY") ||
		(ticket != null && constantTimeEqual(ticket, place.serverTicket))

	if (!authorised && locals.user)
		if (locals.user.permissionLevel >= 5) authorised = true
		else {
			const owns = await ownsItem(f, locals.user.id, new Place(id))
			if (!owns.ok) error(500, economyConnFailed)
			authorised = owns.value
		}

	if (!authorised && place.privateServer && privateTicket)
		authorised = constantTimeEqual(privateTicket, place.privateTicket)

	if (!authorised) error(403, "Unauthorised")

	const file = Bun.file(`../data/places/${id}`)
	if (!(await file.exists())) return error(404, "File not found")

	return new Response(file)
}
