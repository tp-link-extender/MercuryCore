import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { likeSwitch } from "$lib/server/like"
import { error, fail } from "@sveltejs/kit"

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

	return {
		...getPlace,
		likeCount: squery(
			surql`count((SELECT * FROM place:${sid}<-likes).in)`,
		) as Promise<number>,
		dislikeCount: squery(
			surql`count((SELECT * FROM place:${sid}<-dislikes).in)`,
		) as Promise<number>,
		likes: !!(await squery(
			surql`user:${user.id} ∈ (SELECT * FROM place:${sid}<-likes).in`,
		)),
		dislikes: !!(await squery(
			surql`user:${user.id} ∈ (SELECT * FROM place:${sid}<-dislikes).in`,
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

		await likeSwitch(action, user.id, "place", id.toString())
	},

	join: async ({ request, locals }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			requestType = data.request,
			serverId = parseInt(data.serverId)

		if (!requestType || !serverId)
			return fail(400, { message: "Invalid Request" })
		if (requestType != "RequestGame")
			return fail(400, {
				message: "Invalid Request (request type invalid)",
			})

		const place = await prisma.place.findUnique({
			where: {
				id: serverId,
			},
		})
		if (!place) return fail(404, { message: "Place not found" })

		const userModeration = await prisma.moderationAction.findMany({
			where: {
				moderateeId: user.id,
				active: true,
			},
		})

		if (userModeration[0])
			return fail(400, { message: "You cannot currently play games" })

		await prisma.gameSessions.updateMany({
			// invalidate all game sessions
			where: { userId: user.id },
			data: { valid: false },
		})

		const session = await prisma.gameSessions.create({
				// create valid session
				data: {
					place: {
						connect: {
							id: serverId,
						},
					},
					user: {
						connect: {
							id: user.id,
						},
					},
				},
			}),
			joinScriptUrl = `https://banland.xyz/game/join?ticket=${session.ticket}`

		return { joinScriptUrl }
	},
}
