import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { query, squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error } from "@sveltejs/kit"

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)

	const number = parseInt(params.number),
		{ user } = await authorise(locals),
		userExists = await query<{
			bio: {
				id: string
				text: string
				updated: string
			}
			follower: boolean
			followerCount: number
			following: boolean
			followingCount: number
			friendCount: number
			friends: boolean
			groups: {
				memberCount: number
				name: string
			}[]
			groupsOwned: {
				memberCount: number
				name: string
			}[]
			incomingRequest: boolean
			number: number
			outgoingRequest: boolean
			permissionLevel: number
			places: {
				dislikeCount: number
				id: string
				likeCount: number
				name: string
				playerCount: number
			}[]
			posts: {
				content: {
					id: string
					text: string
					updated: string
				}[]
				id: string
				posted: string
				visibility: string
			}[]
			status: "Playing" | "Online" | "Offline"
			username: string
		}>(
			surql`
				SELECT
					username,
					number,
					permissionLevel,
					status,
					(SELECT text, updated FROM $parent.bio
					ORDER BY updated DESC)[0] AS bio,
					(SELECT
						*,
						(SELECT text, updated FROM $parent.content
						ORDER BY updated DESC) AS content
					FROM ->posted->statusPost LIMIT 40) AS posts,

					(SELECT
						meta::id(id) AS id,
						name,
						count(
							SELECT * FROM <-playing
							WHERE valid
								AND ping > time::now() - 35s
						) AS playerCount,

						count(<-likes) AS likeCount,
						count(<-dislikes) AS dislikeCount

					FROM ->owns->place) AS places,

					count(<->friends) AS friendCount,
					count(<-follows) AS followerCount,
					count(->follows) AS followingCount,

					$user ∈ <->friends<->user AS friends,
					$user ∈ <-follows<-user AS following,
					$user ∈ ->follows->user AS follower,
					$user ∈ ->request->user AS incomingRequest,
					$user ∈ <-request<-user AS outgoingRequest,

					(SELECT
						name,
						count(<-member) AS memberCount
					FROM ->member->group) AS groups,
					(SELECT
						name,
						count(<-member) AS memberCount
					FROM ->owns->group) AS groupsOwned

				FROM user
				WHERE number = $number`,
			{
				number,
				user: `user:${user.id}`,
			},
		),
		user2 = userExists[0]

	if (!user2) throw error(404, "Not found")

	return user2
}

export const actions = {
	default: async ({ request, locals, params }) => {
		const { user } = await authorise(locals)

		if (!/^\d+$/.test(params.number))
			throw error(400, `Invalid user id: ${params.number}`)
		const number = parseInt(params.number)
		const user2 = await squery<{
			id: string
		}>(
			surql`
				SELECT meta::id(id) AS id
				FROM user WHERE number = $number`,
			{ number },
		)
		if (!user2) throw error(404, "User not found")
		if (user.id == user2.id)
			throw error(400, "You can't friend/follow yourself")

		const data = await formData(request),
			{ action } = data,
			qParams = {
				user: `user:${user.id}`,
				user2: `user:${user2.id}`,
			},
			accept = () =>
				query(
					// The direction of the ->friends relationship matches
					// the direction of the previous ->request relationship.
					surql`
						DELETE $user2->request WHERE out = $user;
						RELATE $user2->friends->$user
							SET time = time::now();
						RELATE $user->notification->$user2 CONTENT {
							type: $type,
							time: time::now(),
							note: $note,
							relativeId: $relativeId,
							read: false,
						}`,
					{
						type: "NewFriend",
						...qParams,
						note: `${user.username} is now friends with you!`,
						relativeId: user.id,
					},
				)

		try {
			switch (action) {
				case "follow":
					await query(
						surql`
							IF $user2 ∉ $user->follows->user {
								RELATE $user->follows->$user2
									SET time = time::now();
								RELATE $user->notification->$user2 CONTENT {
									type: $type,
									time: time::now(),
									note: $note,
									relativeId: $relativeId,
									read: false,
								}
							}`,
						{
							type: "Follower",
							...qParams,
							note: `${user.username} is now following you!`,
							relativeId: user.id,
						},
					)
					break
				case "unfollow":
					await query(
						surql`
							DELETE $user->follows WHERE out = $user2;
							DELETE $user->notification WHERE in = $user
								AND out = $user2 
								AND type = $type
								AND read = false`,
						{
							type: "Follower",
							...qParams,
						},
					)
					break
				case "unfriend":
					await query(
						surql`
							DELETE $user<-friends WHERE in = $user2;
							DELETE $user->friends WHERE out = $user2;
							DELETE $user->notification WHERE in = $user
								AND out = $user2 
								AND type = $type
								AND read = false`,
						{
							type: "NewFriend",
							...qParams,
						},
					)
					break
				case "request":
					if (
						!(
							// Make sure users are not already friends
							(await query(
								surql`$user ∈ $user2->friends->user
									OR $user2 ∈ $user->friends->user`,
								qParams,
							))
						)
					)
						if (
							// If there is already an incoming request, accept it instead
							await query(
								surql`$user ∈ $user2->request->user`,
								qParams,
							)
						)
							await accept()
						else
							await query(
								surql`
									RELATE $user->request->$user2
										SET time = time::now();
									RELATE $user->notification->$user2 CONTENT {
										type: $type,
										time: time::now(),
										note: $note,
										relativeId: $relativeId,
										read: false,
									}`,
								{
									type: "FriendRequest",
									...qParams,
									note: `${user.username} has sent you a friend request.`,
									relativeId: user.id,
								},
							)
					else throw error(400, "Already friends")
					break
				case "cancel":
					await query(
						surql`
							DELETE $user->request WHERE out = $user2;
							DELETE $user->notification WHERE in = $user
								AND out = $user2 
								AND type = $type
								AND read = false`,
						{
							type: "FriendRequest",
							...qParams,
						},
					)
					break
				case "decline":
					await query(
						surql`DELETE $user2->request WHERE out = $user`,
						qParams,
					)
					break
				case "accept":
					if (
						await query(
							surql`$user ∈ $user2->request->user`,
							qParams,
						)
					)
						// Make sure an incoming request exists before accepting
						await accept()
					else throw error(400, "No friend request to accept")
			}
		} catch (e) {
			console.error(e)
			throw e
		}
	},
}
