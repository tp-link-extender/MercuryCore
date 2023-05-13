import { authorise } from "$lib/server/lucia"
import { prisma, findPlaces, findGroups } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"
import { NotificationType } from "@prisma/client"

export async function load({ locals, params }) {
	console.time("user")
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	const userExists = await prisma.authUser.findUnique({
		where: {
			number,
		},
		select: {
			id: true,
			username: true,
			number: true,
			permissionLevel: true,
			posts: {
				orderBy: {
					posted: "desc",
				},
				select: {
					posted: true,
					content: true,
				},
				take: 40,
			},
			bio: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
		},
	})
	if (userExists) {
		const { user } = await authorise(locals)

		const query = {
			user1: user.username,
			user2: userExists.username,
		}
		const query2 = {
			user: userExists.username,
		}

		const places = findPlaces({
			where: {
				ownerUsername: userExists.username,
				privateServer: user.id == userExists.id ? undefined : false,
			},
			select: {
				id: true,
				name: true,
				gameSessions: {
					where: {
						ping: {
							gt: Math.floor(Date.now() / 1000) - 35,
						},
					},
					select: {
						valid: true,
					},
				},
			},
		})

		console.timeEnd("user")

		return {
			...userExists,
			places: places as Promise<
				Awaited<typeof places> & { gameSessions: any[] }[]
			>,
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
				select: {
					name: true,
				},
			}),
			groupsOwned: findGroups({
				where: {
					ownerUsername: userExists.username,
				},
				select: {
					name: true,
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
		const { user } = await authorise(locals)

		if (!/^\d+$/.test(params.number))
			return fail(400, { msg: `Invalid user id: ${params.number}` })
		const number = parseInt(params.number)

		const userExists = await prisma.authUser.findUnique({
			where: {
				number,
			},
		})
		if (
			!userExists ||
			user.id == userExists.id // You can't friend/follow yourself
		)
			return fail(401)

		const data = await formData(request)
		const action = data.action

		const user2Exists = await prisma.authUser.findUnique({
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

		async function accept() {
			await Promise.all([
				Query(
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
				),
				prisma.notification.create({
					data: {
						type: NotificationType.NewFriend,
						senderId: user.id,
						receiverId: userExists?.id || "", // won't be null
						note: `${user.username} is now friends with you!`,
						relativeId: user.id,
					},
				}),
			])
		}

		try {
			switch (action) {
				case "follow":
					await Promise.all([
						Query(
							"friends",
							`
								MERGE (u1:User { name: $user1 })
								MERGE (u2:User { name: $user2 })
								MERGE (u1) -[:follows]-> (u2)
							`,
							query
						),
						prisma.notification.create({
							data: {
								type: NotificationType.Follower,
								senderId: user.id,
								receiverId: userExists?.id || "",
								note: `${user.username} is now following you!`,
								relativeId: user.id,
							},
						}),
					])
					break
				case "unfollow":
					await Promise.all([
						Query(
							"friends",
							`
								MATCH (u1:User { name: $user1 }) -[r:follows]-> (u2:User { name: $user2 })
								DELETE r
							`,
							query
						),
						prisma.notification.deleteMany({
							where: {
								type: NotificationType.Follower,
								senderId: user.id,
								receiverId: userExists?.id || "",
								read: false,
							},
						}),
					])
					break
				case "unfriend":
					await Promise.all([
						Query(
							"friends",
							`
								MATCH (u1:User { name: $user1 }) -[r:friends]- (u2:User { name: $user2 })
								DELETE r
							`,
							query
						),
						prisma.notification.deleteMany({
							where: {
								type: NotificationType.NewFriend,
								senderId: user.id,
								receiverId: userExists?.id || "",
								read: false,
							},
						}),
					])
					break
				case "request":
					if (
						!(await roQuery(
							"friends",
							"MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r",
							query
						))
					)
						if (
							await roQuery(
								"friends",
								"MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r",
								query
							)
						)
							// Make sure users are not already friends
							// If there is already an incoming request, accept it instead
							await accept()
						else
							await Promise.all([
								Query(
									"friends",
									`
												MERGE (u1:User { name: $user1 })
												MERGE (u2:User { name: $user2 })
												MERGE (u1) -[:request]-> (u2)
											`,
									query
								),
								prisma.notification.create({
									data: {
										type: NotificationType.FriendRequest,
										senderId: user.id,
										receiverId: userExists?.id || "",
										note: `${user.username} has sent you a friend request.`,
										relativeId: user.id,
									},
								}),
							])
					else return fail(400)
					break
				case "cancel":
					await Promise.all([
						Query(
							"friends",
							`
								MATCH (u1:User { name: $user1 }) -[r:request]-> (u2:User { name: $user2 })
								DELETE r
							`,
							query
						),
						prisma.notification.deleteMany({
							where: {
								type: NotificationType.FriendRequest,
								senderId: user.id,
								receiverId: userExists?.id || "",
								read: false,
							},
						}),
					])
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
						await accept()
					else return fail(400)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
