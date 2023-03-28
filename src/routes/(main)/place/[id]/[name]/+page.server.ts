import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"

export async function load({ url, locals, params }) {
	console.time("place")
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)
	const id = parseInt(params.id)

	const privateServerCode = url.searchParams.get("privateServer")

	const getPlace = await prisma.place.findUnique({
		where: { id },
		select: {
			id: true,
			name: true,
			serverPing: true,
			serverTicket: true,
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
			GameSessions: {
				where: {
					ping: {
						gt: Math.floor(Date.now() / 1000) - 35,
					},
				},
				include: {
					user: {
						select: {
							username: true,
							number: true,
							image: true,
						},
					},
				},
			},
		},
	})

	console.timeEnd("place")
	if (getPlace) {
		const { session, user } = await authorise(locals)

		if (
			user.number != getPlace.ownerUser?.number &&
			getPlace.privateServer &&
			privateServerCode != getPlace.privateTicket
		)
			throw error(404, "Not Found")

		const query = {
			user: user.username,
			id,
		}

		return {
			...getPlace,
			likeCount: roQuery(
				"places",
				"RETURN SIZE((:User) -[:likes]-> (:Place { name: $id }))",
				query,
				true
			),
			dislikeCount: roQuery(
				"places",
				"RETURN SIZE((:User) -[:dislikes]-> (:Place { name: $id }))",
				query,
				true
			),
			likes: session
				? roQuery(
						"places",
						"MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $id }) RETURN r",
						query
				  )
				: false,
			dislikes: session
				? roQuery(
						"places",
						"MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $id }) RETURN r",
						query
				  )
				: false,
		}
	} else throw error(404, "Not found")
}

export const actions = {
	like: async ({ request, locals, params }) => {
		if (!/^\d+$/.test(params.id))
			throw error(400, `Invalid place id: ${params.id}`)
		const id = parseInt(params.id)

		const { user } = await authorise(locals)
		const data = await formData(request)
		const action = data.action
		const privateTicket = data.privateTicket

		const place = await prisma.place.findUnique({
			where: {
				id,
			},
		})
		if (
			!place ||
			(place.privateServer && privateTicket != place.privateTicket)
		)
			return fail(404, { msg: "Not found" })

		const query = {
			user: user.username,
			id,
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "like":
					await Query(
						"places",
						`
							MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Place { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"places",
						`
							MERGE (u:User { name: $user })
							MERGE (p:Place { name: $id })
							MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						"places",
						`
							MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $id })
							DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						"places",
						`
							MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"places",
						`
							MERGE (u:User { name: $user })
							MERGE (p:Place { name: $id })
							MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						"places",
						`
							MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Place { name: $id })
							DELETE r
						`,
						query
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
	join: async ({ request, locals }) => {
		const { user } = await authorise(locals)

		const data = await formData(request)

		const requestType = data.request
		const serverId = parseInt(data.serverId)

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
		})

		const joinScriptUrl = `https://banland.xyz/Game/Join.ashx?ticket=${session.ticket}`

		return { joinScriptUrl }
	},
}
