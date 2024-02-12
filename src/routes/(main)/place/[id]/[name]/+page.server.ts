import { authorise } from "$lib/server/lucia"
import surreal, { mquery, squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeActions } from "$lib/server/like"
import { error } from "@sveltejs/kit"

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
	ownerUser: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
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
	if (!/^\d+$/.test(params.id)) error(400, `Invalid place id: ${params.id}`)

	const { user } = await authorise(locals)
	const id = parseInt(params.id)
	const privateServerCode = url.searchParams.get("privateServer")
	const getPlace = await squery<Place>(
		surql`
			SELECT
				meta::id(id) AS id,
				name,
				(SELECT text, updated FROM $parent.description
				ORDER BY updated DESC)[0] AS description,
				serverPing,
				serverTicket,
				privateServer,
				privateTicket,
				created,
				updated,
				maxPlayers,
				(SELECT username, status, number
				FROM <-owns<-user)[0] AS ownerUser,
				(SELECT
					in.username AS username,
					"Playing" AS status, # duh
					in.number AS number
				FROM <-playing
				WHERE valid AND ping > time::now() - 35s) AS players,

				count((SELECT * FROM $parent<-likes).in) AS likeCount,
				count((SELECT * FROM $parent<-dislikes).in) AS dislikeCount,
				$user ∈ (SELECT * FROM $parent<-likes).in AS likes,
				$user ∈ (SELECT * FROM $parent<-dislikes).in AS dislikes
			FROM $place`,
		{
			user: `user:${user.id}`,
			place: `place:${id}`,
		}
	)

	if (
		!getPlace ||
		(user.number !== getPlace.ownerUser.number &&
			getPlace.privateServer &&
			privateServerCode !== getPlace.privateTicket)
	)
		error(404, "Place not found")

	return getPlace
}

export const actions = {
	like: async ({ url, request, locals, params }) => {
		if (!/^\d+$/.test(params.id))
			error(400, `Invalid place id: ${params.id}`)

		const id = parseInt(params.id)
		const { user } = await authorise(locals)
		const data = await formData(request)
		const action = data.action as keyof typeof likeActions
		const privateTicket = url.searchParams.get("privateTicket")
		const place = (
			(await surreal.select(`place:${id}`)) as {
				privateServer: boolean
				privateTicket: string
			}[]
		)[0]

		if (
			!place ||
			(place.privateServer && privateTicket !== place.privateTicket)
		)
			error(404, "Place not found")

		await likeActions[action](user.id, `place:${id}`)
	},

	join: async ({ request, locals }) => {
		const { user } = await authorise(locals)
		const data = await formData(request)
		const requestType = data.request
		const serverId = parseInt(data.serverId)

		if (!requestType || !serverId) error(400, "Invalid Request")
		if (requestType !== "RequestGame")
			error(400, "Invalid Request (request type invalid)")

		if (!(await surreal.select(`place:${serverId}`))[0])
			error(404, "Place not found")

		if (
			await squery<{
				type: string
				note: string
				time: string
				timeEnds: string
			}>(
				surql`
					SELECT 1 FROM moderation
					WHERE out = $user AND active = true`,
				{ user: `user:${user.id}` }
			)
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
			joinScriptUrl: `https://banland.xyz/game/join?ticket=${
				session.id.split(":")[1]
			}`,
		}
	},
}
