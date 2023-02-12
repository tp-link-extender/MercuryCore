import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("item")
	const getItem = await prisma.item.findUnique({
		where: {
			id: params.id,
		},
		select: {
			name: true,
			creator: {
				select: {
					number: true,
					displayname: true,
				},
			},
		},
	})
	console.timeEnd("item")

	if (getItem) {
		const session = await locals.validateUser()

		const query = {
			params: {
				user: session.user?.username || "",
				itemid: params.id,
			},
		}
		return {
			name: getItem.name,
			creator: getItem.creator,
			description: "item description", //getItem.description,
			likeCount: roQuery("RETURN SIZE(() -[:likes]-> (:Item { name: $itemid }))", query, true),
			dislikeCount: roQuery("RETURN SIZE(() -[:dislikes]-> (:Item { name: $itemid }))", query, true),
			likes: session ? roQuery("MATCH (:User { name: $user }) -[r:likes]-> (:Item { name: $itemid }) RETURN r", query) : false,
			dislikes: session ? roQuery("MATCH (:User { name: $user }) -[r:dislikes]-> (:Item { name: $itemid }) RETURN r", query) : false,
		}
	} else throw error(404, `Not found: /item/${params.id}`)
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		if (
			!(await prisma.item.findUnique({
				where: {
					id: params.id,
				},
			}))
		)
			return fail(404, { msg: `Not found: /place/${params.place}` })

		const query = {
			params: {
				user: session.user.username,
				itemid: params.id, // place slug (unique)
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "like":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Item { name: $itemid })
						MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:likes]-> (p:Item { name: $itemid })
						DELETE r
						`,
						query
					)
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (p:Item { name: $itemid })
						MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:dislikes]-> (p:Item { name: $itemid })
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
