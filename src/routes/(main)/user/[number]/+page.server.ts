import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma, findPlaces, findGroups } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"
import { NotificationType } from "@prisma/client"

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)

	const number = parseInt(params.number),
		userExists = await prisma.authUser.findUnique({
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
		const { user } = await authorise(locals),
			query = {
				user1: user.username,
				user2: userExists.username,
			},
			query2 = {
				user: userExists.username,
			},
			places = findPlaces({
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

		return {
			...userExists,
			places: places as Promise<
				Awaited<typeof places> & { gameSessions: any[] }[]
			>,
			groups: [],
			// findGroups({
			// 	where: {
			// 		OR: await roQuery(
			// 			"groups",
			// 			cql`
			// 				MATCH (:User { name: $user }) -[:in]-> (u:Group)
			// 				RETURN u.name AS name`,
			// 			query2,
			// 			false,
			// 			true,
			// 		),
			// 	},
			// 	select: {
			// 		name: true,
			// 	},
			// }),
			groupsOwned: findGroups({
				where: {
					ownerUsername: userExists.username,
				},
				select: {
					name: true,
				},
			}),
			friendCount: squery(
				surql`count(user:${userExists.id}->friends->user)
					+ count(user:${userExists.id}<-friends<-user)`,
			),
			followerCount: squery(
				surql`count(user:${userExists.id}<-follows<-user)`,
			),
			followingCount: squery(
				surql`count(user:${userExists.id}->follows->user)`,
			),
			friends: squery(
				surql`user:${userExists.id} ∈ user:${user.id}->friends->user
					OR user:${user.id} ∈ user:${userExists.id}->friends->user`,
			),
			following: squery(
				surql`user:${userExists.id} ∈ user:${user.id}->follows->user`,
			),
			follower: squery(
				surql`user:${userExists.id} ∈ user:${user.id}<-follows<-user`,
			),
			incomingRequest: squery(
				surql`user:${user.id} ∈ user:${userExists.id}->request->user`,
			),
			outgoingRequest: squery(
				surql`user:${userExists.id} ∈ user:${user.id}->request->user`,
			),
		}
	}

	throw error(404, "Not found")
}

export const actions = {
	default: async ({ request, locals, params }) => {
		const { user } = await authorise(locals)

		if (!/^\d+$/.test(params.number))
			return fail(400, { msg: `Invalid user id: ${params.number}` })
		const number = parseInt(params.number),
			userExists = await prisma.authUser.findUnique({
				where: {
					number,
				},
			})
		if (
			!userExists ||
			user.id == userExists.id // You can't friend/follow yourself
		)
			return fail(401)

		const data = await formData(request),
			{ action } = data,
			user2Exists = await prisma.authUser.findUnique({
				where: {
					username: userExists?.username,
				},
			})
		if (!user2Exists) return fail(400, { msg: "User not found" })

		const accept = () =>
			Promise.all([
				squery(
					// The direction of the ->friends relationship matches
					// the direction of the previous ->request relationship.
					surql`
						DELETE user:${userExists.id}->request WHERE out=user:${user.id};
						RELATE user:${user.id}->friends->user:${userExists.id}
							SET time = time::now()`,
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

		try {
			switch (action) {
				case "follow":
					await Promise.all([
						squery(
							surql`
								IF user:${userExists.id} ∉ user:${user.id}->follows->user THEN
									RELATE user:${user.id}->follows->user:${userExists.id}
										SET time = time::now()
								END`,
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
						squery(
							surql`DELETE user:${user.id}->follows WHERE out=user:${userExists.id}`,
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
						squery(
							surql`DELETE user:${user.id}->friends WHERE out=user:${userExists.id}`,
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
						!(
							// Make sure users are not already friends
							(await squery(
								surql`user:${user.id} ∈ user:${userExists.id}->friends->user
								OR user:${userExists.id} ∈ user:${user.id}->friends->user`,
							))
						)
					)
						if (
							// If there is already an incoming request, accept it instead
							await squery(
								surql`user:${user.id} ∈ user:${userExists.id}->request->user`,
							)
						)
							await accept()
						else
							await Promise.all([
								squery(surql`RELATE user:${user.id}->request->user:${userExists.id}
									SET time = time::now()`),
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
						squery(
							surql`DELETE user:${user.id}->request WHERE out=user:${userExists.id}`,
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
					await squery(
						surql`DELETE user:${userExists.id}->request WHERE out=user:${user.id}`,
					)
					break
				case "accept":
					if (
						await squery(
							surql`user:${user.id} ∈ user:${userExists.id}->request->user`,
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
