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
			name: true,
			description: true,
			image: true,
			maxPlayers: true,
			created: true,
			updated: true,
			ownerUser: {
				select: {
					number: true,
					displayname: true,
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
			name: getPlace.name,
			owner: getPlace.ownerUser,
			description: getPlace.description,
			image: getPlace.image,
			maxPlayers: getPlace.maxPlayers,
			created: getPlace.created,
			updated: getPlace.updated,
			likeCount: roQuery("RETURN SIZE(() -[:likes]-> (:Place { name: $place }))", query, true),
			dislikeCount: roQuery("RETURN SIZE(() -[:dislikes]-> (:Place { name: $place }))", query, true),
			likes: session ? roQuery("MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $place }) RETURN r", query) : false,
			dislikes: session ? roQuery("MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $place }) RETURN r", query) : false,
		}
	} else throw error(404, "Not found")
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
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
}
