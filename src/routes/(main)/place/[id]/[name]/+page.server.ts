import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import surreal, { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeSwitch } from "$lib/server/like"
import { error } from "@sveltejs/kit"

export async function load({ url, locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)

	const { user } = await authorise(locals),
		id = parseInt(params.id),
		privateServerCode = url.searchParams.get("privateServer"),
		getPlace = (
			(await squery(
				surql`
					SELECT
						string::split(type::string(id), ":")[1] AS id,
						name,
						serverPing,
						serverTicket,
						privateServer,
						privateTicket,
						created,
						updated,
						maxPlayers,
						(SELECT
							username,
							number
						FROM <-owns<-user)[0] AS ownerUser,
						(SELECT
							in.username AS username,
							in.number AS number
						FROM <-playing
						WHERE valid
							AND ping > time::now() - 35s) AS players,
						description[0] AS description,

						count((SELECT * FROM $parent<-likes).in) AS likeCount,
						count((SELECT * FROM $parent<-dislikes).in) AS dislikeCount,
						$user ∈ (SELECT * FROM $parent<-likes).in AS likes,
						$user ∈ (SELECT * FROM $parent<-dislikes).in AS dislikes
					FROM $place`,
				{
					user: `user:${user.id}`,
					place: `place:${id}`,
				},
			)) as {
				created: string
				description: {
					id: string
					text: string
					updated: string
				}[]
				dislikeCount: number
				dislikes: boolean
				id: string
				likeCount: number
				likes: boolean
				maxPlayers: number
				name: string
				ownerUser: {
					number: number
					username: string
				}
				players: {
					number: number
					username: string
				}[]
				privateServer: boolean
				privateTicket: string
				serverPing: number
				serverTicket: string
				updated: string
			}[]
		)[0]

	if (
		!getPlace ||
		(user.number != getPlace.ownerUser.number &&
			getPlace.privateServer &&
			privateServerCode != getPlace.privateTicket)
	)
		throw error(404, "Not Found")

	return getPlace
}

export const actions = {
	like: async ({ url, request, locals, params }) => {
		if (!/^\d+$/.test(params.id))
			throw error(400, `Invalid place id: ${params.id}`)

		const id = parseInt(params.id),
			{ user } = await authorise(locals),
			data = await formData(request),
			{ action } = data,
			privateTicket = url.searchParams.get("privateTicket"),
			place = (
				(await surreal.select(`place:${id}`)) as {
					privateServer: boolean
					privateTicket: string
				}[]
			)[0]

		if (
			!place ||
			(place.privateServer && privateTicket != place.privateTicket)
		)
			throw error(404, "Place not found")

		await likeSwitch(action, user.id, `place:${id.toString()}`)
	},

	join: async ({ request, locals }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			requestType = data.request,
			serverId = parseInt(data.serverId)

		if (!requestType || !serverId) throw error(400, "Invalid Request")
		if (requestType != "RequestGame")
			throw error(400, "Invalid Request (request type invalid)")

		if (!(await surreal.select(`place:${serverId}`))[0])
			throw error(404, "Place not found")

		if (
			(
				(await squery(
					surql`
						SELECT *
						FROM moderation
						WHERE out = $user
							AND active = true`,
					{ user: `user:${user.id}` },
				)) as {
					type: string
					note: string
					time: string
					timeEnds: string
				}[]
			)[0]
		)
			throw error(403, "You cannot currently play games")

		//  invalidate all game sessions and create valid session
		const session = (
			(await squery(
				surql`
					UPDATE (SELECT * FROM $user->playing) SET valid = false;
					RELATE $user->playing->$place CONTENT {
						ping: 0,
						valid: true,
					}`,
				{
					user: `user:${user.id}`,
					place: `place:${serverId}`,
				},
			)) as {
				id: string
				in: string
				out: string
				ping: number
				valid: boolean
			}[]
		)[1]

		return {
			joinScriptUrl: `https://banland.xyz/game/join?ticket=${session.id}`,
		}
	},
}
