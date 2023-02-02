import type { Actions, PageServerLoad } from "./$types"
import { prisma, findPlaces } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	console.time("user")
	if (!/^\d+$/.test(params.number)) throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	const user = await prisma.user.findUnique({
		where: {
			number,
		},
		select: {
			number: true,
			username: true,
			displayname: true,
			bio: true,
			image: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				take: 40,
			},
		},
	})
	if (user) {
		const session = await locals.validateUser()

		const query = {
			params: {
				user1: session.user.username || "",
				user2: user.username,
			},
		}
		const query2 = {
			params: {
				user: user.username,
			},
		}

		console.timeEnd("user")
		return {
			number: user.number,
			username: user.username,
			displayname: user.displayname,
			bio: user.bio,
			img: user.image,
			places: findPlaces({
				where: {
					owner: {
						username: user.username,
					},
				},
			}),
			feed: user.posts,
			friendCount: roQuery("RETURN SIZE(() -[:friends]- (:User { name: $user }))", query2, true),
			followerCount: roQuery("RETURN SIZE(() -[:follows]-> (:User { name: $user }))", query2, true),
			followingCount: roQuery("RETURN SIZE(() <-[:follows]- (:User { name: $user }))", query2, true),
			friends: roQuery("MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r", query),
			following: roQuery("MATCH (:User { name: $user1 }) -[r:follows]-> (:User { name: $user2 }) RETURN r", query),
			follower: roQuery("MATCH (:User { name: $user1 }) <-[r:follows]- (:User { name: $user2 }) RETURN r", query),
			incomingRequest: roQuery("MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query),
			outgoingRequest: roQuery("MATCH (:User { name: $user1 }) -[r:request]-> (:User { name: $user2 }) RETURN r", query),
		}
	} else {
		throw error(404, `Not found: /user/${params.userid}`)
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		if (!/^\d+$/.test(params.number)) throw error(400, `Invalid user id: ${params.number}`)
		const number = parseInt(params.number)

		const user = await prisma.user.findUnique({
			where: {
				number,
			},
			select: {
				username: true,
			},
		})

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const user2 = await prisma.user.findUnique({
			where: {
				username: user?.username,
			},
		})
		if (!user2) return fail(400, { msg: "User not found" })

		const query = {
			params: {
				user1: session.user.username,
				user2: user?.username,
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
