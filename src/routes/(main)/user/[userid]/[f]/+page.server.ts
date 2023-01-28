import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

const types = ["friends", "followers", "following"]

const usersQueries: any = {
	friends: `
		MATCH (:User { name: $user }) -[r:friends]-> (u:User)
		RETURN u.name AS name`,
	followers: `
		MATCH (:User { name: $user }) <-[r:follows]- (u:User)
		RETURN u.name AS name`,
	following: `
		MATCH (:User { name: $user }) -[r:follows]-> (u:User)
		RETURN u.name AS name`,
}

const numberQueries: any = {
	friends: "RETURN SIZE((:User { name: $user }) -[:friends]-> ())",
	followers: "RETURN SIZE((:User { name: $user }) <-[:follows]- ())",
	following: "RETURN SIZE((:User { name: $user }) -[:follows]-> ())",
}

export const load: PageServerLoad = async ({ params }) => {
	console.time("user")
	if (!/^\d+$/.test(params.userid)) throw error(400, `Invalid user id: ${params.userid}`)
	const id = parseInt(params.userid)

	if (params.f && !types.includes(params.f)) throw error(400, `Not found: /user/${params.userid}/${params.f}`)
	const type = params.f

	const user = await prisma.user.findUnique({
		where: {
			id,
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
				usersQueries[type],
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
			type,
			username: user.username,
			displayname: user.displayname,
			img: user.image,
			users: Users(),
			number: roQuery(numberQueries[type], query, true),
		}
	} else {
		throw error(404, `Not found`)
	}
}
