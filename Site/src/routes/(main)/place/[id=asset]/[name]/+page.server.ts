import fs from "node:fs"
import { error, redirect } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formData from "$lib/server/formData"
import { startGameserver } from "$lib/server/orbiter"
import ratelimit from "$lib/server/ratelimit"
import { db, findWhere, Record } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import findPlaceQuery from "./findPlace.surql"
import invalidatePlayingQuery from "./invalidatePlaying.surql"
import placeQuery from "./place.surql"

type FoundPlace = {
	ownerUsername: string
	privateServer: boolean
	privateTicket: string
}

interface Place extends FoundPlace {
	created: string
	description: {
		text: string
		updated: string
	}
	dislikeCount: number
	dislikes: boolean
	id: number
	likeCount: number
	likes: boolean
	maxPlayers: number
	name: string
	ownerUser: BasicUser
	players: {
		status: "Playing"
		username: string
	}[]
	serverPing: number
	serverTicket: string
	updated: string
}

const thumbnails = config.Images.DefaultPlaceThumbnails

export async function load({ locals, params, url }) {
	const { user } = await authorise(locals)
	const privateTicket = url.searchParams.get("privateServer")
	const id = +params.id
	const [[place]] = await db.query<Place[][]>(placeQuery, {
		user: Record("user", user.id),
		place: Record("place", id),
	})
	if (!place) error(404, "Place not found")

	const isOwner = user.username === place.ownerUser.username
	if (
		!isOwner &&
		place.privateServer &&
		privateTicket !== place.privateTicket
	)
		error(404, "Place not found")

	if (!isOwner || user.permissionLevel !== 5) place.serverTicket = ""

	// ahh, reminds me of early Mercury 2
	const slug = encode(place.name)
	if (!couldMatch(place.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	// don't check gameserver status here or your mercury will slow to a crawl

	return {
		scheme: config.LauncherURI,
		hosting: config.Gameservers.Hosting,
		orbiterURL: `https://${config.OrbiterPublicDomain}`,
		slug,
		place,
		thumbnails: [id % thumbnails.length],
	}
}

async function findPlace(request: Request, id: number, user: User) {
	const data = await formData(request)
	const privateTicket = data?.privateTicket

	const placeR = Record("place", id)
	const [[place]] = await db.query<FoundPlace[][]>(findPlaceQuery, {
		place: placeR,
	})

	if (
		!place ||
		(user.username !== place.ownerUsername &&
			place.privateServer &&
			privateTicket !== place.privateTicket)
	)
		error(404, "Place not found")

	return placeR
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
actions.join = async ({ locals, params, request }) => {
	const user = await checkUser(locals)
	const placeR = await findPlace(request, +params.id, user)

	// Invalidate all game sessions and create valid playing
	const [, [ticket]] = await db.query<string[][]>(invalidatePlayingQuery, {
		user: Record("user", user.id),
		place: placeR,
	})

	return { ticket }
}

actions.start = async ({ locals, params, request, getClientAddress }) => {
	const user = await checkUser(locals)

	const limit = ratelimit(null, "serverstart", getClientAddress, 20)
	if (limit) return limit

	const id = +params.id
	await findPlace(request, id, user)

	// check for existence of a place file
	const placeFile = `../data/places/${id}`
	if (!fs.existsSync(placeFile)) error(404, "Place file not found")

	const res = await startGameserver(id)
	if (!res.ok) {
		console.error(
			"Failed to start dedicated gameserver for id",
			id,
			res.msg
		)
		error(500, "Failed to start dedicated server")
	}
}
