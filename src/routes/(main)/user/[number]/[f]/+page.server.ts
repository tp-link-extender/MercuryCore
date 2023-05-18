// The friends, followers, and following pages for a user.

import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

const types = ["friends", "followers", "following"]

const usersQueries = {
	friends: `
		MATCH (:User { name: $user }) -[:friends]- (u:User)
		RETURN u.name AS name`,
	followers: `
		MATCH (:User { name: $user }) <-[:follows]- (u:User)
		RETURN u.name AS name`,
	following: `
		MATCH (:User { name: $user }) -[:follows]-> (u:User)
		RETURN u.name AS name`,
}

const numberQueries = {
	friends: "RETURN SIZE((:User { name: $user }) -[:friends]- (:User))",
	followers: "RETURN SIZE((:User { name: $user }) <-[:follows]- (:User))",
	following: "RETURN SIZE((:User { name: $user }) -[:follows]-> (:User))",
}

export const load = async ({ params }) => {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	if (params.f && !types.includes(params.f)) throw error(400, "Not found")
	const type = params.f as "friends" | "followers" | "following"
	console.time("user " + type)

	const user = await prisma.authUser.findUnique({
		where: {
			number,
		},
	})
	if (user) {
		const query = {
			user: user.username,
		}

		console.timeEnd("user " + type)
		return {
			type,
			username: user.username,
			users: prisma.authUser.findMany({
				where: {
					username: {
						in: (
							await roQuery(
								"friends",
								usersQueries[type],
								query,
								false,
								true
							)
						).map((i: any) => i.name),
					},
				},
				select: {
					username: true,
					number: true,
				},
			}),
			number: roQuery("friends", numberQueries[type], query, true),
		}
	}

	throw error(404, `Not found`)
}
