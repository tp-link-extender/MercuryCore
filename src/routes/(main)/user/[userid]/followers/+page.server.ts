import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ params }) => {
	console.time("user")
	params.userid = params.userid
	if (!/^\d+$/.test(params.userid)) throw error(400, `Invalid user id: ${params.userid}`)
	params.userid = parseInt(params.userid)

	const user = await prisma.user.findUnique({
		where: {
			id: params.userid,
		},
		select: {
			username: true,
			displayname: true,
			image: true,
		},
	})
	if (user) {
		const query = {
			params: {
				user: user?.username,
			},
		}

		async function Users() {
			const usersQuery = await roQuery(
				`
				MATCH (:User { name: $user }) -[r:friends]-> (u:User)
				RETURN u.name AS name
				`,
				query,
				false,
				true
			)

			let users: any[] = []

			for (let i of usersQuery || ([] as any)) {
				if (i.name)
					users.push(
						await prisma.user.findUnique({
							where: {
								username: i.name,
							},
							select: {
								id: true,
								username: true,
								displayname: true,
								image: true,
								status: true,
							},
						})
					)
			}

			return users
		}

		console.timeEnd("user")
		return {
			username: params.user,
			displayname: user.displayname,
			img: user.image,
			users: Users(),
			number: roQuery("RETURN SIZE((:User { name: $user }) <-[:follows]- ())", query, true),
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}
