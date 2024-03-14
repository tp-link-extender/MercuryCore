import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { fail, error } from "@sveltejs/kit"
import requestRender from "$lib/server/requestRender"
import type { RequestEvent } from "./$types"

type User = {
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
}

export async function load({ locals, params }) {
	const number = +params.number
	const { user } = await authorise(locals)
	const userExists = await squery<User>(
		// You could start with five or six queries, or ~just one~
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
						SELECT 1 FROM <-playing
						WHERE valid AND ping > time::now() - 35s
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

				(SELECT name, count(<-member) AS memberCount
				FROM ->member->group) AS groups,
				(SELECT name, count(<-member) AS memberCount
				FROM ->owns->group) AS groupsOwned
			FROM user WHERE number = $number`,
		{
			number,
			user: `user:${user.id}`,
		}
	)

	if (!userExists) error(404, "Not found")

	return userExists
}

async function getData({ params }: RequestEvent) {
	if (!/^\d+$/.test(params.number))
		error(400, `Invalid user id: ${params.number}`)
	const user2 = await squery<{
		id: string
		username: string
	}>(
		surql`
			SELECT meta::id(id) AS id, username
			FROM user WHERE number = $number`,
		{ number: +params.number }
	)
	if (!user2) error(404, "User not found")

	return { user2 }
}

type ActionFunction = (
	params: {
		user: string
		user2: string
	},
	user: import("lucia").User
) => Promise<unknown>

const acceptExisting: ActionFunction = (params, user) =>
	query(
		// The direction of the ->friends relationship matches the direction of the previous ->request relationship.
		surql`
			DELETE $user2->request WHERE out = $user;
			RELATE $user2->friends->$user SET time = time::now();
			RELATE $user->notification->$user2 CONTENT {
				type: $type,
				time: time::now(),
				note: $note,
				relativeId: $relativeId,
				read: false,
			}`,
		{
			type: "NewFriend",
			...params,
			note: `${user.username} is now friends with you!`,
			relativeId: user.id,
		}
	)

async function getInteractData(e: RequestEvent) {
	const { request, locals } = e
	const { user } = await authorise(locals)
	const { user2 } = await getData(e)

	if (user.id === user2.id) error(400, "You can't friend/follow yourself")

	return {
		user,
		params: {
			user: `user:${user.id}`,
			user2: `user:${user2.id}`,
		},
		data: await formData(request),
	}
}

export const actions = {
	follow: async e => {
		const { user, params } = await getInteractData(e)
		await query(
			surql`
				IF $user2 ∉ $user->follows->user {
					RELATE $user->follows->$user2 SET time = time::now();
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
				...params,
				note: `${user.username} is now following you!`,
				relativeId: user.id,
			}
		)
	},
	unfollow: async e => {
		const { params } = await getInteractData(e)
		await query(
			surql`
				DELETE $user->follows WHERE out = $user2;
				DELETE $user->notification WHERE out = $user2
					AND type = $type
					AND read = false`,
			{
				type: "Follower",
				...params,
			}
		)
	},
	unfriend: async e => {
		const { params } = await getInteractData(e)
		await query(
			surql`
				DELETE $user<-friends WHERE in = $user2;
				DELETE $user->friends WHERE out = $user2;
				DELETE $user->notification WHERE out = $user2
					AND type = $type
					AND read = false`,
			{
				type: "NewFriend",
				...params,
			}
		)
	},
	request: async e => {
		const { user, params } = await getInteractData(e)
		if (
			// Make sure users are not already friends
			!(await query(
				surql`$user ∈ $user2->friends->user
					OR $user2 ∈ $user->friends->user`,
				params
			))
		)
			if (await query(surql`$user ∈ $user2->request->user`, params))
				// If there is already an incoming request, accept it instead
				await acceptExisting(params, user)
			else
				await query(
					surql`
						RELATE $user->request->$user2 SET time = time::now();
						RELATE $user->notification->$user2 CONTENT {
							type: $type,
							time: time::now(),
							note: $note,
							relativeId: $relativeId,
							read: false,
						}`,
					{
						type: "FriendRequest",
						...params,
						note: `${user.username} has sent you a friend request.`,
						relativeId: user.id,
					}
				)
		else error(400, "Already friends")
	},
	cancel: async e => {
		const { params } = await getInteractData(e)
		await query(
			surql`
				DELETE $user->request WHERE out = $user2;
				DELETE $user->notification WHERE out = $user2
					AND type = $type
					AND read = false`,
			{
				type: "FriendRequest",
				...params,
			}
		)
	},
	decline: async e => {
		const { params } = await getInteractData(e)
		await query(surql`DELETE $user2->request WHERE out = $user`, params)
	},
	accept: async e => {
		const { user, params } = await getInteractData(e)
		// Make sure an incoming request exists before accepting
		if (!(await query(surql`$user ∈ $user2->request->user`, params)))
			error(400, "No friend request to accept")

		await acceptExisting(params, user)
	},
	rerender: async e => {
		const { locals, params } = e
		await authorise(locals, 5)

		const { user2 } = await getData(e)

		try {
			await requestRender("Avatar", +params.number, true)
			return {
				avatarBody: `/api/avatar/${
					user2.username
				}-body?r=${Math.random()}`,
				avatar: `/api/avatar/${user2.username}?r=${Math.random()}`,
			}
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}
	},
}
