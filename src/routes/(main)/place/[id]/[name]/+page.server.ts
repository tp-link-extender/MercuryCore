import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeSwitch } from "$lib/server/like"
import { error } from "@sveltejs/kit"

export async function load({ url, locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)

	const id = parseInt(params.id),
		sid = id.toString(),
		privateServerCode = url.searchParams.get("privateServer"),
		getPlace = await prisma.place.findUnique({
			where: { id },
			select: {
				id: true,
				name: true,
				serverPing: true,
				serverTicket: true,
				privateServer: true,
				privateTicket: true,
				created: true,
				updated: true,
				maxPlayers: true,

				ownerUser: {
					select: {
						username: true,
						number: true,
					},
				},
				description: {
					orderBy: {
						updated: "desc",
					},
					select: {
						text: true,
					},
					take: 1,
				},
				gameSessions: {
					where: {
						ping: {
							gt: Math.floor(Date.now() / 1000) - 35,
						},
					},
					select: {
						user: {
							select: {
								username: true,
								number: true,
							},
						},
					},
				},
			},
		})

	if (!getPlace) throw error(404, "Not found")

	const { user } = await authorise(locals)

	if (
		user.number != getPlace.ownerUser?.number &&
		getPlace.privateServer &&
		privateServerCode != getPlace.privateTicket
	)
		throw error(404, "Not Found")

	const query = {
		user: `user:${user.id}`,
		place: `place:${sid}`,
	}

	return {
		...getPlace,
		likeCount: squery(
			surql`count((SELECT * FROM $place<-likes).in)`,
			query,
		) as Promise<number>,
		dislikeCount: squery(
			surql`count((SELECT * FROM $place<-dislikes).in)`,
			query,
		) as Promise<number>,
		likes: !!(await squery(
			surql`$user ∈ (SELECT * FROM $place<-likes).in`,
			query,
		)),
		dislikes: !!(await squery(
			surql`$user ∈ (SELECT * FROM $place<-dislikes).in`,
			query,
		)),
	}
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
			place = await prisma.place.findUnique({
				where: {
					id,
				},
			})

		if (
			!place ||
			(place.privateServer && privateTicket != place.privateTicket)
		)
			throw error(404, "Not found")

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

		const place = await prisma.place.findUnique({
			where: {
				id: serverId,
			},
		})
		if (!place) throw error(404, "Place not found")

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

		// invalidate all game sessions
		await squery(
			surql`
				UPDATE (SELECT * FROM $user->playing)
					SET valid = false`,
			{
				user: `user:${user.id}`,
			},
		)

		// create valid session
		const session = (await squery(
			surql`
				RELATE $user->playing->$place
					CONTENT {
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
		}

		return {
			joinScriptUrl: `https://banland.xyz/game/join?ticket=${session.id}`,
		}
	},
}
