import type { Actions, PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

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
			owner: {
				select: {
					number: true,
					displayname: true,
				},
			},
		},
	})
	console.timeEnd("place")
	if (getPlace) {
		const session = await locals.validateUser()

		const query = {
			params: {
				user: session.user?.username || "",
				place: params.place,
			},
		}

		return {
			name: getPlace.name,
			owner: getPlace.owner,
			description: getPlace.description,
			image: getPlace.image,
			likeCount: roQuery("RETURN SIZE(() -[:likes]-> (:Place { name: $place }))", query, true),
			dislikeCount: roQuery("RETURN SIZE(() -[:dislikes]-> (:Place { name: $place }))", query, true),
			likes: session ? roQuery("MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $place }) RETURN r", query) : false,
			dislikes: session ? roQuery("MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $place }) RETURN r", query) : false,
		}
	} else throw error(404, `Not found: /${params.place}`)
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		if (
			!(await prisma.place.findUnique({
				where: {
					slug: params.place,
				},
			}))
		)
			return fail(404, { msg: `Not found: /place/${params.place}` })

		const query = {
			params: {
				user: session.user.username,
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
