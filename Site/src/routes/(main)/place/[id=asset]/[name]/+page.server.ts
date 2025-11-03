import { error, redirect } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formData from "$lib/server/formData"
import { getGameserver } from "$lib/server/orbiter"
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

	const dedicatedProps: { dedicatedOnline?: boolean } = {}

	const hosting = config.Gameservers.Hosting
	if (hosting === "Dedicated hosting" || hosting === "Both") {
		const status = await getGameserver(id)
		dedicatedProps.dedicatedOnline = status.ok
	}

	return {
		scheme: config.LauncherURI,
		hosting,
		...dedicatedProps,
		slug,
		place,
		thumbnails: [id % thumbnails.length],
	}
}

export const actions: import("./$types").Actions = {}
actions.join = async ({ locals, params, request }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const privateTicket = data?.privateTicket

	const id = +params.id
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

	const foundModerated = await findWhere(
		"moderation",
		"out = $user AND active = true",
		{ user: Record("user", user.id) }
	)
	if (foundModerated) error(403, "You cannot currently play games")

	// Invalidate all game sessions and create valid playing
	const [, [playing]] = await db.query<{ id: string }[][]>(
		invalidatePlayingQuery,
		{
			user: Record("user", user.id),
			place: placeR,
		}
	)

	return { ticket: playing.id }
}
