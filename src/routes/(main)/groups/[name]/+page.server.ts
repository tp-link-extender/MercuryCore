import cql from "$lib/cyphertag"
import { authorise } from "$lib/server/lucia"
import { prisma, findPlaces } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"

export async function load({ locals, params }) {
	const group = await prisma.group.findUnique({
		where: {
			name: params.name,
		},
		include: {
			owner: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 40,
			},
		},
	})

	if (group) {
		const { user } = await authorise(locals),
			query = {
				group: group.name,
			},
			query2 = {
				user: user.username,
				group: group.name,
			}

		return {
			name: group.name,
			owner: group.owner,
			places: findPlaces({
				where: {
					ownerGroup: {
						name: group.name,
					},
				},
			}),
			feed: group.posts,
			memberCount: roQuery(
				"groups",
				cql`RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))`,
				query,
				true,
			),
			in: roQuery(
				"groups",
				cql`MATCH (:User { name: $user }) -[r:in]-> (:Group { name: $group }) RETURN r`,
				query2,
			),
		}
	}

	throw error(404, "Not found")
}

export const actions = {
	default: async ({ request, locals, params }) => {
		const { user } = await authorise(locals),
			group = await prisma.group.findUnique({
				where: {
					name: params.name,
				},
				select: {
					name: true,
				},
			})

		if (!group) return fail(400, { msg: "User not found" })

		const data = await formData(request),
			{ action } = data,
			query = {
				user: user.username,
				group: group.name,
			}

		try {
			switch (action) {
				case "join":
					await Query(
						"groups",
						cql`
							MERGE (u:User { name: $user })
							MERGE (g:Group { name: $group })
							MERGE (u) -[:in]-> (g)`,
						query,
					)
					break
				case "leave":
					await Query(
						"groups",
						cql`
							MATCH (u:User { name: $user }) -[r:in]-> (g:Group { name: $group })
							DELETE r`,
						query,
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
