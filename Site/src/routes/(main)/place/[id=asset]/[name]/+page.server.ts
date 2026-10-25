import fs from "node:fs"
import { error, redirect } from "@sveltejs/kit"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import {
	economyConnFailed,
	itemOwner,
	type OwnedUser,
	ownsItem,
} from "$lib/server/economy"
import formData from "$lib/server/formData"
import { closeGameserver, startGameserver } from "$lib/server/orbiter"
import ratelimit from "$lib/server/ratelimit"
import { db, findWhere, Record } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import findPlaceQuery from "./findPlace.surql"
import invalidatePlayingQuery from "./invalidatePlaying.surql"
import placeQuery from "./place.surql"

type FoundPlace = {
	privateServer: boolean
	privateTicket: string
	clientVersion: number
}

interface Place extends FoundPlace {
	created: string
	description: string
	dislikeCount: number
	dislikes: boolean
	id: number
	likeCount: number
	likes: boolean
	maxPlayers: number
	name: string
	clientVersion: number
	ownerUser: OwnedUser | null
	players: {
		status: "Playing"
		username: string
	}[]
	serverPing: number
	serverTicket: string
	updated: Date
}

const thumbnails = config.Images.DefaultPlaceThumbnails

export async function load({ fetch: f, locals, params, url }) {
	const { user } = await authorise(locals)
	const privateTicket = url.searchParams.get("privateServer")
	const id = +params.id
	const [[place]] = await db.query<Place[][]>(placeQuery, {
		user: Record("user", user.id),
		place: Record("place", id),
	})
	if (!place) error(404, "Place not found")

	const owner = await itemOwner(f, new Econ.Place(id))
	if (!owner.ok) error(500, economyConnFailed)
	place.ownerUser = owner.value

	const isOwner = place.ownerUser?.id === user.id
	if (
		!isOwner &&
		place.privateServer &&
		privateTicket !== place.privateTicket
	)
		error(404, "Place not found")

	if (!isOwner && user.permissionLevel !== 5) place.serverTicket = ""

	// ahh, reminds me of early Mercury 2
	const slug = encode(place.name)
	if (!couldMatch(place.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	// don't check gameserver status here or your mercury will slow to a crawl

	return {
		scheme: config.LauncherURI,
		clientVersion: place.clientVersion,
		hosting: config.Gameservers.Hosting,
		orbiterURL: config.Orbiter.PublicURL,
		slug,
		place,
		thumbnails: [id % thumbnails.length],
	}
}

async function findPlace(
	f: typeof globalThis.fetch,
	request: Request,
	id: number,
	user: User
) {
	const data = await formData(request)
	const privateTicket = data?.privateTicket

	const placeR = Record("place", id)
	const [[place]] = await db.query<FoundPlace[][]>(findPlaceQuery, {
		place: placeR,
	})
	if (!place) error(404, "Place not found")

	const owns = await ownsItem(f, user.id, new Econ.Place(id))
	if (!owns.ok) error(500, economyConnFailed)

	if (
		!owns.value &&
		place.privateServer &&
		privateTicket !== place.privateTicket
	)
		error(404, "Place not found")

	return [place, placeR, owns.value] as const
}

async function checkUser(locals: App.Locals) {
	const { user } = await authorise(locals)

	const foundModerated = await findWhere(
		"moderation",
		"out = $user AND active = true",
		{ user: Record("user", user.id) }
	)
	if (foundModerated) error(403, "You cannot currently play games")

	return user
}

export const actions: import("./$types").Actions = {}
actions.join = async ({ fetch: f, locals, params, request }) => {
	const user = await checkUser(locals)
	const [_, placeR] = await findPlace(f, request, +params.id, user)

	// Invalidate all game sessions and create valid playing
	const [, [ticket]] = await db.query<string[][]>(invalidatePlayingQuery, {
		user: Record("user", user.id),
		place: placeR,
	})

	return { ticket }
}

actions.start = async ({
	fetch: f,
	locals,
	params,
	request,
	getClientAddress,
}) => {
	const user = await checkUser(locals)

	const limit = ratelimit(null, "serverstart", getClientAddress, 20)
	if (limit) return limit

	const id = +params.id
	const [_place, _placeR] = await findPlace(f, request, id, user)

	// check for existence of a place file
	const placeFile = `../data/places/${id}`
	if (!fs.existsSync(placeFile)) error(404, "Place file not found")

	const res = await startGameserver(f, id, _place.clientVersion)
	if (res.ok) return

	console.error("Failed to start dedicated gameserver for id", id, res.msg)
	error(500, "Failed to start dedicated server")
}

actions.close = async ({ fetch: f, locals, params, request }) => {
	const { user } = await authorise(locals)
	const id = +params.id

	const [, , isOwner] = await findPlace(f, request, id, user)

	if (!isOwner && user.permissionLevel < 4)
		error(403, "You do not have permission to close this server.")

	const res = await closeGameserver(f, id)
	if (res.ok) return

	console.error("Failed to close dedicated gameserver for id", id, res.msg)
	error(500, "Failed to close dedicated server")
}
