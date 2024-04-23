import { authorise } from "$lib/server/lucia"
import { mquery, squery, surql, find, findWhere } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeLikesActions, type LikeActions } from "$lib/server/like"
import { publish } from "$lib/server/realtime"
import { encode, couldMatch } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"

type Place = {
	created: string
	description: {
		text: string
		updated: string
	}
	dislikeCount: number
	dislikes: boolean
	id: string
	likeCount: number
	likes: boolean
	maxPlayers: number
	name: string
	ownerUser: BasicUser
	players: {
		number: number
		status: "Playing"
		username: string
	}[]
	privateServer: boolean
	privateTicket: string
	serverPing: number
	serverTicket: string
	updated: string
}

export async function load({ url, locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const privateServerCode = url.searchParams.get("privateServer")
	const getPlace = await squery<Place>(import("./place.surql"), {
		user: `user:${user.id}`,
		place: `place:${id}`,
	})

	if (
		!getPlace ||
		(user.number !== getPlace.ownerUser.number &&
			getPlace.privateServer &&
			privateServerCode !== getPlace.privateTicket)
	)
		error(404, "Place not found")

	// ahh, reminds me of early Mercury 2
	const slug = encode(getPlace.name)

	if (!couldMatch(getPlace.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	return {
		slug,
		place: getPlace,
	}
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ url, request, locals, params }) => {
	const id = +params.id
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as LikeActions
	const privateTicket = url.searchParams.get("privateTicket")

	const foundPlace = await squery<{
		privateServer: boolean
		privateTicket: string
		likeCount: number
		dislikeCount: number
	}>(
		surql`
			SELECT
				privateServer,
				privateTicket,
				count(SELECT 1 FROM $parent<-likes) AS likeCount,
				count(SELECT 1 FROM $parent<-dislikes) AS dislikeCount
			FROM $place`,
		{ place: `place:${id}` }
	)

	if (
		!foundPlace ||
		(foundPlace.privateServer && privateTicket !== foundPlace.privateTicket)
	)
		error(404, "Place not found")

	const likes = await likeLikesActions[action](user.id, `place:${id}`)

	foundPlace.likeCount = likes.likeCount
	foundPlace.dislikeCount = likes.dislikeCount
	await publish(`place:${id}`, {
		// cant destructure foundPlace because it contains sensitive data
		id,
		...likes,
		action,
		hash: user.realtimeHash,
	})
}
actions.join = async ({ request, locals }) => {
	const { user } = await authorise(locals)
	const data = await formData(request)
	const requestType = data.request
	const serverId = +data.serverId

	if (!requestType || !serverId) error(400, "Invalid Request")
	if (requestType !== "RequestGame")
		error(400, "Invalid Request (request type invalid)")

	if (!(await find(`place:${serverId}`))) error(404, "Place not found")

	if (
		await findWhere("moderation", surql`out = $user AND active = true`, {
			user: `user:${user.id}`,
		})
	)
		error(403, "You cannot currently play games")

	// Invalidate all game sessions and create valid session
	const sessionQ = await mquery<
		{
			id: string
			in: string
			out: string
			ping: number
			valid: boolean
		}[][]
	>(
		surql`
			UPDATE (SELECT * FROM $user->playing) SET valid = false;
			RELATE $user->playing->$place CONTENT {
				ping: 0,
				valid: true,
			}`,
		{
			user: `user:${user.id}`,
			place: `place:${serverId}`,
		}
	)
	const session = sessionQ[1][0]

	return {
		joinScriptUrl: `${process.env.ORIGIN}/game/join?ticket=${
			session.id.split(":")[1]
		}`,
	}
}
