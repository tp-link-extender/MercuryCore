import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ params }) => {
	console.time("user")
	params.user = params.user.toLowerCase()
	const user = await prisma.user.findUnique({
		where: {
			username: params.user,
		},
		select: {
			displayname: true,
			image: true,
		},
	})
	if (user) {
		async function Users() {
			const usersQuery = await roQuery(
				`
				MATCH (:User { name: $user1 }) -[r:friends]-> (u:User)
				RETURN u.name AS name
				`,
				{
					params: {
						user1: params.user,
					},
				}, false, true
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

		const query = {
			params: {
				user: params.user,
			},
		}

		console.timeEnd("user")
		return {
			username: params.user,
			displayname: user.displayname,
			img: user.image,
			users: Users(),
			number: roQuery("RETURN SIZE((:User { name: $user }) -[:friends]-> ())", query, true),
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}
