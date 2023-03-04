import type { PageServerLoad, Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma, findPlaces, findGroups } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("user")
	if (!/^\d+$/.test(params.number)) throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	const userExists = await prisma.user.findUnique({
		where: {
			number,
		},
		select: {
			number: true,
			username: true,
			displayname: true,
			bio: true,
			image: true,
			permissionLevel: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 40,
			},
		},
	})
	if (userExists) {
		const user = (await authoriseUser(locals.validateUser())).user

		const query = {
			params: {
				user1: user?.username || "",
				user2: userExists.username,
			},
		}
		const query2 = {
			params: {
				user: userExists.username,
			},
		}

		console.timeEnd("user")
		return {
			number: userExists.number,
			username: userExists.username,
			displayname: userExists.displayname,
			bio: userExists.bio,
			img: userExists.image,
			permissionLevel: userExists.permissionLevel,
			places: findPlaces({
				where: {
					ownerUsername: userExists.username,
					privateServer: false,
				},
			}),
			groups: findGroups({
				where: {
					OR: await roQuery(
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
			feed: userExists.posts,
			friendCount: roQuery("RETURN SIZE((:User) -[:friends]- (:User { name: $user }))", query2, true),
			followerCount: roQuery("RETURN SIZE((:User) -[:follows]-> (:User { name: $user }))", query2, true),
			followingCount: roQuery("RETURN SIZE((:User) <-[:follows]- (:User { name: $user }))", query2, true),
			friends: roQuery("MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r", query),
			following: roQuery("MATCH (:User { name: $user1 }) -[r:follows]-> (:User { name: $user2 }) RETURN r", query),
			follower: roQuery("MATCH (:User { name: $user1 }) <-[r:follows]- (:User { name: $user2 }) RETURN r", query),
			incomingRequest: roQuery("MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query),
			outgoingRequest: roQuery("MATCH (:User { name: $user1 }) -[r:request]-> (:User { name: $user2 }) RETURN r", query),
		}
	} else {
		throw error(404, "Not found")
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const user = (await authoriseUser(locals.validateUser())).user

		if (!/^\d+$/.test(params.number)) throw error(400, `Invalid user id: ${params.number}`)
		const number = parseInt(params.number)

		const userExists = await prisma.user.findUnique({
			where: {
				number,
			},
			select: {
				username: true,
			},
		})

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const user2Exists = await prisma.user.findUnique({
			where: {
				username: userExists?.username,
			},
		})
		if (!user2Exists) return fail(400, { msg: "User not found" })

		const query = {
			params: {
				user1: user.username,
				user2: userExists?.username,
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "follow":
					await Query(
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
						`
							MATCH (u1:User { name: $user1 }) -[r:follows]-> (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "unfriend":
					await Query(
						`
							MATCH (u1:User { name: $user1 }) -[r:friends]- (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "request":
					if (!(await roQuery("MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r", query))) {
						// Make sure users are not already friends
						if (await roQuery("MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
							// If there is already an incoming request, accept it instead
							await Query(
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
						`
							MATCH (u1:User { name: $user1 }) -[r:request]-> (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "decline":
					await Query(
						`
							MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
							DELETE r
						`,
						query
					)
					break
				case "accept":
					if (await roQuery("MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
						// Make sure an incoming request exists before accepting
						await Query(
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
