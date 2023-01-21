import type { Actions, PageServerLoad } from "./$types"
import { error, fail, redirect, type Page } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import graph from "$lib/server/redis"
import { createClient, Graph } from "redis"

const prisma = new PrismaClient()

async function roQuery(graph: any, str: string, query: any) {
	try {
		return ((await graph.roQuery(str, query)).data || [])[0]
	} catch {
		return false
	}
}
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
			ownerUsername: true,
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

		// this is a stupid bug. previously just returning the result of a roQuery as "data" or whatever, then using .data, would break randomly
		const c = () => "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.random() * 52)
		const rand: any = Array(5).fill(0).map(c).join("")

		return {
			name: getPlace.name,
			owner: getPlace.ownerUsername,
			description: getPlace.description,
			image: getPlace.image,
			likeCount: (await roQuery(graph, `RETURN SIZE(() -[:likes]-> (:Place { name: $place })) as ${rand}`, query))[rand],
			dislikeCount: (await roQuery(graph, `RETURN SIZE(() -[:dislikes]-> (:Place { name: $place })) as ${rand}`, query))[rand],
			likes: session ? roQuery(graph, "MATCH (:User { name: $user }) -[r:likes]-> (:Place { name: $place }) RETURN r", query) : false,
			dislikes: session ? roQuery(graph, "MATCH (:User { name: $user }) -[r:dislikes]-> (:Place { name: $place }) RETURN r", query) : false,
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
				select: {
					name: true,
					description: true,
					image: true,
					ownerUsername: true,
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
					await graph.query(
						`
						MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Place { name: $place })
						DELETE r
						`,
						query
					)
					await graph.query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Place { name: $place })
						MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await graph.query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $place })
						DELETE r
						`,
						query
					)
					break
				case "dislike":
					await graph.query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Place { name: $place })
						DELETE r
						`,
						query
					)
					await graph.query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Place { name: $place })
						MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await graph.query(
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
