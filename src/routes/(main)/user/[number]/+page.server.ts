import { authorise } from "$lib/server/lucia"
import { prisma, findPlaces, findGroups } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"

export async function load({ locals, params }) {
	console.time("user")
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	const userExists = await prisma.user.findUnique({
		where: {
			number,
		},
		include: {
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 40,
			},
		},
	})
	if (userExists) {
		const { user } = await authorise(locals.validateUser)

		const query = {
			user1: user.username,
			user2: userExists.username,
		}
		const query2 = {
			user: userExists.username,
		}

		console.timeEnd("user")
		return {
			...userExists,
			places: findPlaces({
				where: {
					ownerUsername: userExists.username,
					privateServer: false,
				},
				include: {
					GameSessions: {
						where: {
							ping: {
								gt: Math.floor(Date.now() / 1000) - 35,
							},
						},
					},
				},
			}),
			groups: findGroups({
				where: {
					OR: await roQuery(
						"groups",
						`
							MATCH (:User { name: $user }) -[:in]-> (u:Group)
							RETURN u.name AS name
						`,
						query2,
						false,
						true
					),
				},
			}),
			groupsOwned: findGroups({
				where: {
					ownerUsername: userExists.username,
				},
			}),
			friendCount: roQuery(
				"friends",
				"RETURN SIZE((:User) -[:friends]- (:User { name: $user }))",
				query2,
				true
			),
			followerCount: roQuery(
				"friends",
				"RETURN SIZE((:User) -[:follows]-> (:User { name: $user }))",
				query2,
				true
			),
			followingCount: roQuery(
				"friends",
				"RETURN SIZE((:User) <-[:follows]- (:User { name: $user }))",
				query2,
				true
			),
			friends: roQuery(
				"friends",
				"MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r",
				query
			),
			following: roQuery(
				"friends",
				"MATCH (:User { name: $user1 }) -[r:follows]-> (:User { name: $user2 }) RETURN r",
				query
			),
			follower: roQuery(
				"friends",
				"MATCH (:User { name: $user1 }) <-[r:follows]- (:User { name: $user2 }) RETURN r",
				query
			),
			incomingRequest: roQuery(
				"friends",
				"MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r",
				query
			),
			outgoingRequest: roQuery(
				"friends",
				"MATCH (:User { name: $user1 }) -[r:request]-> (:User { name: $user2 }) RETURN r",
				query
			),
		}
	} else throw error(404, "Not found")
}

export const actions = {
	default: async ({ request, locals, params }) => {
		const { user } = await authorise(locals.validateUser)

		if (!/^\d+$/.test(params.number))
			throw error(400, `Invalid user id: ${params.number}`)
		const number = parseInt(params.number)

		const userExists = await prisma.user.findUnique({
			where: {
				number,
			},
		})
		if (!userExists) return fail(401)

		const data = await formData(request)
		const action = data.action

		const user2Exists = await prisma.user.findUnique({
			where: {
				username: userExists?.username,
			},
		})
		if (!user2Exists) return fail(400, { msg: "User not found" })

		const query = {
			user1: user.username,
			user2: userExists.username,
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "follow":
					await Query(
						"friends",
						`
							MERGE (u1:User { name: $user1 })
							MERGE (u2:User { name: $user2 })
							MERGE (u1) -[:follows]-> (u2)
						`,
						query
					)
					break
				case "unfollow":
					await Query(
						"friends",
						`
							MATCH (u1:User { name: $user1 }) -[r:follows]-> (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "unfriend":
					await Query(
						"friends",
						`
							MATCH (u1:User { name: $user1 }) -[r:friends]- (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "request":
					if (
						!(await roQuery(
							"friends",
							"MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r",
							query
						))
					) {
						// Make sure users are not already friends
						if (
							await roQuery(
								"friends",
								"MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r",
								query
							)
						)
							// If there is already an incoming request, accept it instead
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
							)
						else
							await Query(
								"friends",
								`
									MERGE (u1:User { name: $user1 })
									MERGE (u2:User { name: $user2 })
									MERGE (u1) -[:request]-> (u2)
								`,
								query
							)
					} else return fail(400)
					break
				case "cancel":
					await Query(
						"friends",
						`
							MATCH (u1:User { name: $user1 }) -[r:request]-> (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
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
					if (
						await roQuery(
							"friends",
							"MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r",
							query
						)
					)
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
