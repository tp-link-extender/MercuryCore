import type { Actions, PageServerLoad } from "./$types"
import { prisma, findPlaces } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("group")

	const group = await prisma.group.findUnique({
		where: {
			name: params.name,
		},
		select: {
			name: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 40,
			},
		},
	})
	if (group) {
		const session = await locals.validateUser()

		const query = {
			params: {
				group: group.name,
			},
		}

		const query2 = {
			params: {
				user: session.user.username || "",
				group: group.name,
			},
		}

		console.timeEnd("group")
		return {
			name: group.name,
			places: findPlaces({
				where: {
					ownerGroup: {
						name: group.name,
					},
				},
			}),
			feed: group.posts,
			followerCount: roQuery("RETURN SIZE((:User) -[:follows]-> (:Group { name: $group }))", query, true),
			memberCount: roQuery("RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))", query, true),
			following: roQuery("MATCH (:User { name: $user }) -[r:follows]-> (:Group { name: $group }) RETURN r", query2),
			in: roQuery("MATCH (:User { name: $user }) -[r:in]-> (:Group { name: $group }) RETURN r", query2),
		}
	} else {
		throw error(404, `Not found: /group/${params.name}`)
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const group = await prisma.group.findUnique({
			where: {
				name: params.name,
			},
			select: {
				name: true,
			},
		})
		if (!group) return fail(400, { msg: "User not found" })

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const query = {
			params: {
				user: session.user.username,
				group: group.name,
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "join":
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (g:Group { name: $group })
						MERGE (u) -[:in]-> (g)
						`,
						query
					)
					break
				case "leave":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:in]-> (g:Group { name: $group })
						DELETE r
						`,
						query
					)
					break
				case "follow":
					await Query(
						`
						MERGE (u:User { name: $user })
						MERGE (g:Group { name: $group })
						MERGE (u) -[:follows]-> (g)
						`,
						query
					)
					break
				case "unfollow":
					await Query(
						`
						MATCH (u:User { name: $user }) -[r:follows]-> (g:Group { name: $group })
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
