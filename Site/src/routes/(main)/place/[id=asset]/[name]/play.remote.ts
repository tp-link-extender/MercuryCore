import fs from "node:fs"
import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import constantTimeEqual from "#lib/server/constantTimeEqual.ts"
import { usesDedicated } from "#lib/server/dedicated.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { closeGameserver, startGameserver } from "#lib/server/orbiter.ts"
import { ratelimit, ratelimitKey } from "#lib/server/ratelimit.ts"
import { db, Record } from "#lib/server/surreal.ts"
import { command, form, getRequestEvent } from "$app/server"
import findPlaceQuery from "./findPlace.surql"
import invalidatePlayingQuery from "./invalidatePlaying.surql"

interface FoundPlace {
	clientVersion: number
	dedicated: boolean
	privateServer: boolean
	privateTicket: string
}

// Place ids are numbers
const placeIdSchema = type("string | number").pipe(String)

const playSchema = type({
	id: placeIdSchema,
	privateTicket: "string",
})

const closeSchema = type({
	id: placeIdSchema,
})

/** Whether the ticket supplied by the client opens a private place. */
const ticketMatches = (supplied: unknown, place: FoundPlace): boolean =>
	typeof supplied === "string" &&
	supplied !== "" &&
	constantTimeEqual(supplied, place.privateTicket)

async function findPlace(id: string, privateTicket: string) {
	const { fetch: f, locals } = getRequestEvent()
	const { user } = await authorise(locals)
	const placeId = Number(id)

	const placeR = Record("place", placeId)
	const [[place]] = await db.query<FoundPlace[][]>(findPlaceQuery, {
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

export const join = command(playSchema, async ({ id, privateTicket }) => {
	const { placeR, user } = await findPlace(id, privateTicket)

	// Invalidate all game sessions and create valid playing
	const [, [ticket]] = await db.query<string[][]>(invalidatePlayingQuery, {
		place: placeR,
		user: Record("user", user.id),
	})

	return { ticket }
})

export const start = command(playSchema, async ({ id, privateTicket }) => {
	const { fetch: f, getClientAddress } = getRequestEvent()
	const { place, placeId, user } = await findPlace(id, privateTicket)

	// Self-hosted places don't use a dedicated server, so there's nothing to start
	if (!usesDedicated(place.dedicated)) return { dedicated: false }

	// A start requested recently means the server is already on its way, so wait for that one
	const limited =
		ratelimit("serverstart", getClientAddress, 20) ||
		ratelimitKey("serverstart", user.id, 20)
	if (limited) return { dedicated: true }

	// check for existence of a place file
	const placeFile = `../data/places/${placeId}`
	if (!fs.existsSync(placeFile)) error(404, "Place file not found")

	const res = await startGameserver(f, placeId, place.clientVersion)
	if (res.ok) return { dedicated: true }

	console.error(
		"Failed to start dedicated gameserver for id",
		placeId,
		res.msg
	)
	error(500, "Failed to start dedicated server")
})

export const closeForm = form(closeSchema, async ({ id }) => {
	const { fetch: f, locals } = getRequestEvent()
	const { user } = await authorise(locals)
	const placeId = Number(id)

	// Not findPlace, as its private ticket check would hide private places from moderators
	if (user.permissionLevel < 4) {
		const owns = await ownsItem(f, user.id, new EconPlace(placeId))
		if (!owns.ok) error(500, economyConnFailed)
		if (!owns.value)
			error(403, "You do not have permission to close this server.")
	}

	const res = await closeGameserver(f, placeId)
	if (res.ok) return

	console.error(
		"Failed to close dedicated gameserver for id",
		placeId,
		res.msg
	)
	error(500, "Failed to close dedicated server")
})
