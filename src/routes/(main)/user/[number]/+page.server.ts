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
				user: `user:${user.id}`,
				user2: `user:${userExists.id}`,
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
				surql`count($user2->friends->user)
					+ count($user2<-friends<-user)`,
				query,
			),
			followerCount: squery(surql`count($user2<-follows<-user)`, query),
			followingCount: squery(surql`count($user2->follows->user)`, query),
			friends: squery(
				surql`$user2 ∈ $user->friends->user
					OR $user ∈ $user2->friends->user`,
				query,
			),
			following: squery(surql`$user2 ∈ $user->follows->user`, query),
			follower: squery(surql`$user2 ∈ $user<-follows<-user`, query),
			incomingRequest: squery(
				surql`$user ∈ $user2->request->user`,
				query,
			),
			outgoingRequest: squery(
				surql`$user2 ∈ $user->request->user`,
				query,
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
		if (!userExists) return error(404, "User not found")
		if (user.id == userExists.id)
			// You can't friend/follow yourself
			return error(400, "You can't friend/follow yourself")

		const data = await formData(request),
			{ action } = data,
			user2Exists = await prisma.authUser.findUnique({
				where: {
					username: userExists?.username,
				},
			})
		if (!user2Exists) return error(400, "User not found")

		const query = {
				user: `user:${user.id}`,
				user2: `user:${userExists.id}`,
			},
			accept = () =>
				Promise.all([
					squery(
						// The direction of the ->friends relationship matches
						// the direction of the previous ->request relationship.
						surql`
						DELETE $user2->request WHERE out=$user;
						RELATE $user2->friends->$user
							SET time = time::now()`,
						query,
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
								IF $user2 ∉ $user->follows->user THEN
									RELATE $user->follows->$user2
										SET time = time::now()
								END`,
							query,
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
							surql`DELETE $user->follows WHERE out=$user2`,
							query,
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
							surql`
								DELETE $user->friends WHERE out=$user2;
								DELETE $user2->friends WHERE out=$user`,
							query,
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
								surql`$user ∈ $user2->friends->user
								OR $user2 ∈ $user->friends->user`,
								query,
							))
						)
					)
						if (
							// If there is already an incoming request, accept it instead
							await squery(
								surql`$user ∈ $user2->request->user`,
								query,
							)
						)
							await accept()
						else
							await Promise.all([
								squery(
									surql`RELATE $user->request->$user2
									SET time = time::now()`,
									query,
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
						squery(
							surql`DELETE $user->request WHERE out=$user2`,
							query,
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
						surql`DELETE $user2->request WHERE out=$user`,
						query,
					)
					break
				case "accept":
					if (
						await squery(
							surql`$user ∈ $user2->request->user`,
							query,
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
