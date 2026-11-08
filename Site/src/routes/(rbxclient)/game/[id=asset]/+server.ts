import { timingSafeEqual } from "node:crypto"
import { error } from "@sveltejs/kit"
import * as Econ from "economy/types"
import { env } from "$env/dynamic/private"
import { economyConnFailed, ownsItem } from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types"

const placeAccessQuery = `
	SELECT
		privateServer,
		privateTicket,
		serverTicket
	FROM $place;
`

function constantTimeEqual(a: string, b: string): boolean {
	const ah = Buffer.from(a)
	const bh = Buffer.from(b)
	if (ah.byteLength !== bh.byteLength) return false
	return timingSafeEqual(ah, bh)
}

export async function GET({
	fetch: f,
	locals,
	params,
	request,
	url,
}: RequestEvent) {
	const id = Number(params.id)

	const [[place]] = await db.query<
		{
			privateServer: boolean
			privateTicket: string
			serverTicket: string
		}[][]
	>(placeAccessQuery, { place: Record("place", id) })
	if (!place) error(404, "Not Found")

	const gameserverKey = env.GAMESERVER_KEY
	const auth = request.headers.get("Authorization")
	const bearer = auth?.startsWith("Bearer ") ? auth.slice(7) : null
	const ticket = url.searchParams.get("serverTicket")
	const privateTicket = url.searchParams.get("privateTicket")

	let authorised =
		(Boolean(gameserverKey) &&
			Boolean(bearer) &&
			constantTimeEqual(bearer, gameserverKey)) ||
		(Boolean(ticket) && constantTimeEqual(ticket, place.serverTicket))

	if (!authorised && locals.user)
		if (locals.user.permissionLevel >= 5) authorised = true
		else {
			const owns = await ownsItem(f, locals.user.id, new Econ.Place(id))
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
