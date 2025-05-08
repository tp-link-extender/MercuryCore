import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import formData from "$lib/server/formData"
import { type LikeActions, likeLikesActions } from "$lib/server/like"
import { Record, db, find, findWhere } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import findPlaceQuery from "./findPlace.surql"
import invalidateSessionsQuery from "./invalidateSessions.surql"
import placeQuery from "./place.surql"

type FoundPlace = {
	dislikeCount: number
	likeCount: number
	privateServer: boolean
	privateTicket: string
}

type Place = FoundPlace & {
	created: string
	description: {
		text: string
		updated: string
	}
	dislikes: boolean
	id: string
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

type Playing = {
	id: string
	in: string
	out: string
	ping: string
	valid: boolean
}

const thumbnails = config.Images.DefaultPlaceThumbnails

export async function load({ locals, params, url }) {
	const { user } = await authorise(locals)
	const privateServerCode = url.searchParams.get("privateServer")
	const id = +params.id
	const [[place]] = await db.query<Place[][]>(placeQuery, {
		user: Record("user", user.id),
		place: Record("place", id),
	})

	if (
		!place ||
		(user.username !== place.ownerUser.username &&
			place.privateServer &&
			privateServerCode !== place.privateTicket)
	)
		error(404, "Place not found")

	// ahh, reminds me of early Mercury 2
	const slug = encode(place.name)
	if (!couldMatch(place.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	return { slug, place, thumbnails: [id % thumbnails.length] }
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ locals, params, request, url }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as LikeActions
	const privateTicket = url.searchParams.get("privateTicket")

	const id = +params.id
	const [[place]] = await db.query<FoundPlace[][]>(findPlaceQuery, {
		place: Record("place", id),
	})
	if (
		!place ||
		(place.privateServer && privateTicket !== place.privateTicket)
	)
		error(404, "Place not found")

	await likeLikesActions[action](user.id, Record("place", id))
}
actions.join = async ({ locals, request }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const serverId = +data.serverId

	if (!serverId) error(400, "Invalid Request")
	if (!(await find("place", serverId))) error(404, "Place not found")

	const foundModerated = await findWhere(
		"moderation",
		"out = $user AND active = true",
		{ user: Record("user", user.id) }
	)
	if (foundModerated) error(403, "You cannot currently play games")

	// Invalidate all game sessions and create valid playing
	const [, [playing]] = await db.query<Playing[][]>(invalidateSessionsQuery, {
		user: Record("user", user.id),
		place: Record("place", serverId),
	})

	return {
		joinScriptUrl: `${config.Domain}/game/join?ticket=${playing.id}`,
	}
}
