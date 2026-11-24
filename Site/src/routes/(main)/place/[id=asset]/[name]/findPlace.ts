import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import constantTimeEqual from "#lib/server/constantTimeEqual.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import { getRequestEvent } from "$app/server"
import findPlaceQuery from "./findPlace.surql"

interface FoundPlace {
	clientVersion: number
	dedicated: boolean
	privateServer: boolean
	privateTicket: string
}

// Place ids are numbers
export const placeIdSchema = type("string | number").pipe(String)

/** Whether the ticket supplied by the client opens a private place. */
const ticketMatches = (supplied: unknown, place: FoundPlace): boolean =>
	typeof supplied === "string" &&
	supplied !== "" &&
	constantTimeEqual(supplied, place.privateTicket)

/** Finds a place the current user may see, which for a private place means owning it or having its private ticket. */
export async function findPlace(id: string, privateTicket: string) {
	const { fetch: f, locals } = getRequestEvent()
	const { user } = await authorise(locals)
	const placeId = Number(id)
	if (!Number.isSafeInteger(placeId)) error(404, "Place not found")

	const placeR = Record("place", placeId)
	const [[place]] = await dbQuery<FoundPlace[][]>(findPlaceQuery, {
		place: placeR,
	})
	if (!place) error(404, "Place not found")

	const owns = await ownsItem(f, user.id, new EconPlace(placeId))
	if (!owns.ok) error(500, economyConnFailed)

	if (
		!owns.value &&
		place.privateServer &&
		!ticketMatches(privateTicket, place)
	)
		error(404, "Place not found")

	return { isOwner: owns.value, place, placeId, placeR, user }
}
