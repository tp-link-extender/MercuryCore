import config from "$lib/server/config"
import formData from "$lib/server/formData"
import { type LikeActions, likeLikesActions } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import { Record, equery, find, findWhere, surql } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
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

export async function load({ url, locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const privateServerCode = url.searchParams.get("privateServer")
	const [[place]] = await equery<Place[][]>(placeQuery, {
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

	return { slug, place }
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ url, request, locals, params }) => {
	const id = +params.id
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as LikeActions
	const privateTicket = url.searchParams.get("privateTicket")

	const [[foundPlace]] = await equery<FoundPlace[][]>(
		surql`
			SELECT
				privateServer,
				privateTicket,
				count(SELECT 1 FROM $parent<-likes) AS likeCount,
				count(SELECT 1 FROM $parent<-dislikes) AS dislikeCount
			FROM $place`,
		{ place: Record("place", id) }
	)

	if (
		!foundPlace ||
		(foundPlace.privateServer && privateTicket !== foundPlace.privateTicket)
	)
		error(404, "Place not found")

	await likeLikesActions[action](user.id, Record("place", id))
}
actions.join = async ({ request, locals }) => {
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
	const [, [playing]] = await equery<Playing[][]>(
		surql`
			UPDATE (SELECT * FROM $user->playing) SET valid = false;
			RELATE $user->playing->$place CONTENT {
				ping: time::now(), # todo: check
				valid: true,
			} RETURN meta::id(id) AS id`,
		{
			user: Record("user", user.id),
			place: Record("place", serverId),
		}
	)

	return {
		joinScriptUrl: `${config.Domain}/game/join?ticket=${playing.id}`,
	}
}
