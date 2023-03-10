import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

export async function load({ locals, params }) {
	const user = (await authoriseUser(locals.validateUser)).user

	console.time("requests")

	const userExists = await prisma.user.findUnique({
		where: {
			number: user?.number,
		},
		select: {
			username: true,
			image: true,
		},
	})

	const query = {
		params: {
			user: userExists?.username,
		},
	}

	async function Users() {
		const usersQuery = await roQuery(
			"friends",
			`
				MATCH (:User { name: $user }) <-[r:request]- (u:User)
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
							number: true,
							username: true,
							image: true,
							status: true,
						},
					})
				)
		}

		return users
	}

	console.timeEnd("requests")
	return {
		users: Users(),
		number: roQuery("friends", "RETURN SIZE((:User { name: $user }) <-[:request]- (:User))", query, true),
	}
}

export const actions = {
	default: async ({ request, locals }) => {
		const user = (await authoriseUser(locals.validateUser)).user

		const data = await request.formData()
		const action = (data.get("action") as string).split(" ")

		const user2 = await prisma.user.findUnique({
			where: {
				username: action[1],
			},
		})
		if (!user2) return fail(400, { msg: "User not found" })

		const query = {
			params: {
				user1: user.username,
				user2: action[1],
			},
		}

		console.log("Action:", action)

		try {
			switch (action[0]) {
				case "decline":
					await Query(
						"friends",
						`
							MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "accept":
					if (await roQuery("friends", "MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
						// Make sure an incoming request exists before accepting
						await Query(
							"friends",
							`
								MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
								DELETE r
								MERGE (u1)
								MERGE (u2)
								MERGE (u1) <-[:friends]- (u2)
							`,
							query
							// The direction of the [:friends] relationship matches the direction of the previous [:request] relationship
						)
					else return fail(400)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
