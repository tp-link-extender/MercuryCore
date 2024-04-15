import { authorise } from "$lib/server/lucia"
import { mquery, squery, surql, find, findWhere } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeActions } from "$lib/server/like"
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

	const slug = encode(getPlace.name)

	if (!couldMatch(getPlace.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	return { ...getPlace, slug }
}

export const actions: import("./$types").Actions = {}
actions.like = async ({ url, request, locals, params }) => {
	const id = +params.id
	const { user } = await authorise(locals)
	const data = await formData(request)
	const action = data.action as keyof typeof likeActions
	const privateTicket = url.searchParams.get("privateTicket")

	const likePlace = await squery<{
		privateServer: boolean
		privateTicket: string
	}>(surql`SELECT privateServer, privateTicket FROM $place`, {
		place: `place:${id}`,
	})

	if (
		!likePlace ||
		(likePlace.privateServer && privateTicket !== likePlace.privateTicket)
	)
		error(404, "Place not found")

	await likeActions[action](user.id, `place:${id}`)
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
	const session = (
		await mquery<
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
	)[1][0]

	return {
		joinScriptUrl: `${process.env.ORIGIN}/game/join?ticket=${
			session.id.split(":")[1]
		}`,
	}
}
