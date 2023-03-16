import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

export async function load({ url, locals, params }) {
	console.time("place")
	if (!/^\d+$/.test(params.id)) throw error(400, `Invalid place id: ${params.id}`)
	const id = parseInt(params.id)

	const privateServerCode = url.searchParams.get("privateServer")

	const getPlace = await prisma.place.findUnique({
		where: { id },
		include: {
			ownerUser: {
				select: {
					number: true,
					username: true,
				},
			},
			GameSessions: {
				where: {
					ping: {
						gt: Math.floor(Date.now() / 1000) - 35,
					},
				},
				select: {
					user: {
						select: {
							number: true,
							username: true,
							image: true,
						},
					},
				},
			},
		},
	})

	console.timeEnd("place")
	if (getPlace) {
		const { session, user } = await authoriseUser(locals.validateUser)

		if (user?.number != getPlace.ownerUser?.number && getPlace.privateServer && privateServerCode != getPlace.privateTicket) throw error(404, "Not Found")

		const query = {
			params: {
				user: user?.username || "",
				id,
			},
		}

		return {
			...getPlace,
			likeCount: roQuery("places", "RETURN SIZE((:User) -[:likes]-> (:Place { name: $id }))", query, true),
			dislikeCount: roQuery("places", "RETURN SIZE((:User) -[:dislikes]-> (:Place { name: $id }))", query, true),
			likes: session ? roQuery("places", "MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $id }) RETURN r", query) : false,
			dislikes: session ? roQuery("places", "MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $id }) RETURN r", query) : false,
		}
	} else throw error(404, "Not found")
}

export const actions = {
	like: async ({ request, locals, params }) => {
		if (!/^\d+$/.test(params.id)) throw error(400, `Invalid place id: ${params.id}`)
		const id = parseInt(params.id)

		const user = (await authoriseUser(locals.validateUser)).user
		const data = await request.formData()
		const action = data.get("action") as string
		const privateTicket = data.get("privateTicket") as string

		const place = await prisma.place.findUnique({
			where: { id },
			select: {
				privateServer: true,
				privateTicket: true,
			},
		})
		if (!place || (place.privateServer && privateTicket != place.privateTicket)) return fail(404, { msg: "Not found" })

		const query = {
			params: {
				user: user.username,
				id: id,
			},
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
		const user = (await authoriseUser(locals.validateUser)).user

		const data = await request.formData()

		const requestType = data.get("request")
		const serverId = parseInt(data.get("serverId") as string)

		if (!requestType || !serverId) return fail(400, { message: "Invalid Request" })
		if (requestType != "RequestGame") return fail(400, { message: "Invalid Request (request type invalid)" })

		const place = await prisma.place.findUnique({
			where: {
				id: serverId,
			},
			select: {
				maxPlayers: true,
			},
		})
		if (!place) return fail(404, { message: "Place not found" })

		const userModeration = await prisma.moderationAction.findMany({
			where: {
				moderateeId: user.userId,
				active: true,
			}, 
		})
	
		if(userModeration[0]) return fail(400, { message: "You cannot currently play games" })

		// We will use a different method to check if place is full, via GameSessions

		// if (
		// 	place.maxPlayers <=
		// 	(await roQuery("friends",
		// 		"RETURN SIZE ((:User) -[:playing]-> (:Game { name: $id }))",
		// 		{
		// 			params: {
		// 				id: serverId,
		// 			},
		// 		},
		// 		true
		// 	))
		// 	false
		// )
		// 	return fail(400, { message: "Place is currently full. Join back later!" })

		await prisma.gameSessions.updateMany({
			// invalidate all game sessions
			where: { userId: user.userId },
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
						id: user.userId,
					},
				},
			},
			select: {
				ticket: true,
			},
		})

		const joinScriptUrl = `https://banland.xyz/Game/Join.ashx?ticket=${session.ticket}`

		return { joinScriptUrl }
	},
}
