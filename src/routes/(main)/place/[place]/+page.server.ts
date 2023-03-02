import type { PageServerLoad, Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("place")
	const getPlace = await prisma.place.findUnique({
		where: {
			slug: params.place,
		},
		select: {
			id: true,
			name: true,
			description: true,
			image: true,
			maxPlayers: true,
			created: true,
			updated: true,
			slug: true,
			serverTicket: true,
			ownerUser: {
				select: {
					number: true,
					username: true,
				},
			},
		},
	})
	console.timeEnd("place")
	if (getPlace) {
		const { session, user } = await authoriseUser(locals.validateUser())

		const query = {
			params: {
				user: user?.username || "",
				place: params.place,
			},
		}

		return {
			...getPlace,
			likeCount: roQuery("RETURN SIZE(() -[:likes]-> (:Place { name: $place }))", query, true),
			dislikeCount: roQuery("RETURN SIZE(() -[:dislikes]-> (:Place { name: $place }))", query, true),
			likes: session ? roQuery("MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $place }) RETURN r", query) : false,
			dislikes: session ? roQuery("MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $place }) RETURN r", query) : false,
		}
	} else throw error(404, "Not found")
}

export const actions: Actions = {
	like: async ({ request, locals, params }) => {
		const user = (await authoriseUser(locals.validateUser())).user

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		if (
			!(await prisma.place.findUnique({
				where: {
					slug: params.place,
				},
			}))
		)
			return fail(404, { msg: "Not found" })

		const query = {
			params: {
				user: user.username,
				place: params.place, // place slug (unique)
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "like":
					await Query(
						`
							MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Place { name: $place })
							DELETE r
						`,
						query
					)
					await Query(
						`
							MERGE (u:User { name: $user })
							MERGE (p:Place { name: $place })
							MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						`
							MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $place })
							DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						`
							MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $place })
							DELETE r
						`,
						query
					)
					await Query(
						`
							MERGE (u:User { name: $user })
							MERGE (p:Place { name: $place })
							MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						`
							MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Place { name: $place })
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
		const user = (await authoriseUser(locals.validateUser())).user

		const data = await request.formData()

		const requestType = data.get("request")
		const serverID = parseInt(data.get("serverID")?.toString() || "")

		if (!requestType || !serverID) return fail(400, { message: "Invalid Request" })
		if (requestType != "RequestGame") return fail(400, { message: "Invalid Request (request type invalid)" })

		const place = await prisma.place.findUnique({
			where: { id: serverID },
			select: { maxPlayers: true, slug: true },
		})
		if (!place) return fail(404, { message: "Place not found" })
		if (place.maxPlayers <= (await roQuery("RETURN SIZE ((:User) -[:playing]-> (:Game {name: $slug}) )", { params: { slug: place.slug } }, true)))
			return fail(400, { message: "Place is currently full. Join back later!" })

		await prisma.gameSessions.updateMany({ // invalidate all game sessions
			where: {userId: user.userId},
			data: {valid: false}
		})

		const session = await prisma.gameSessions.create({ // create valid session
			data: {place: {connect: {id: serverID}}, user: {connect: {id: user.userId}}},
			select: {ticket: true}
		})

		const joinScriptUrl = `https://banland.xyz/Game/Join.ashx?ticket=${session.ticket}`

		return {joinScriptUrl}
	},
}
