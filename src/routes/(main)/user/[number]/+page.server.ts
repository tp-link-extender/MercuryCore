import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { fail, error } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import type { User } from "lucia"

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)

	const number = parseInt(params.number),
		{ user } = await authorise(locals)
	const userExists = await squery<{
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
		},
	)

	if (!userExists) throw error(404, "Not found")

	return userExists
}

async function getData({
	params,
}: Parameters<(typeof actions)[keyof typeof actions]>[0]) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)
	const user2 = await squery<{
		id: string
		username: string
	}>(
		surql`
			SELECT meta::id(id) AS id, username
			FROM user WHERE number = $number`,
		{ number },
	)
	if (!user2) throw error(404, "User not found")

	return { user2 }
}

type QParams = {
	user: string
	user2: string
}

type ActionFunction = (a1: QParams, a2: User) => Promise<any>

const acceptExisting: ActionFunction = (params, user) =>
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
			...params,
			note: `${user.username} is now friends with you!`,
			relativeId: user.id,
		},
	)

const follow: ActionFunction = (params, user) =>
	query(
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
			...params,
			note: `${user.username} is now following you!`,
			relativeId: user.id,
		},
	)

const unfollow: ActionFunction = params =>
	query(
		surql`
			DELETE $user->follows WHERE out = $user2;
			DELETE $user->notification WHERE in = $user
				AND out = $user2
				AND type = $type
				AND read = false`,
		{
			type: "Follower",
			...params,
		},
	)

const unfriend: ActionFunction = params =>
	query(
		surql`
			DELETE $user<-friends WHERE in = $user2;
			DELETE $user->friends WHERE out = $user2;
			DELETE $user->notification WHERE in = $user
				AND out = $user2
				AND type = $type
				AND read = false`,
		{
			type: "NewFriend",
			...params,
		},
	)

const sendRequest: ActionFunction = async (params, user) => {
	if (
		!(
			// Make sure users are not already friends
			(await query(
				surql`$user ∈ $user2->friends->user
					OR $user2 ∈ $user->friends->user`,
				params,
			))
		)
	)
		if (
			// If there is already an incoming request, accept it instead
			await query(surql`$user ∈ $user2->request->user`, params)
		)
			await acceptExisting(params, user)
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
					...params,
					note: `${user.username} has sent you a friend request.`,
					relativeId: user.id,
				},
			)
	else throw error(400, "Already friends")
}

const cancel: ActionFunction = params =>
	query(
		surql`
			DELETE $user->request WHERE out = $user2;
			DELETE $user->notification WHERE in = $user
				AND out = $user2
				AND type = $type
				AND read = false`,
		{
			type: "FriendRequest",
			...params,
		},
	)

const decline: ActionFunction = params =>
	query(surql`DELETE $user2->request WHERE out = $user`, params)

const accept = async (params: QParams, user: User) => {
	if (await query(surql`$user ∈ $user2->request->user`, params))
		// Make sure an incoming request exists before accepting
		await acceptExisting(params, user)
	else throw error(400, "No friend request to accept")
}

const actionFunctions: { [k: string]: ActionFunction } = {
	follow,
	unfollow,
	unfriend,
	request: sendRequest,
	cancel,
	decline,
	accept,
}

export const actions = {
	interact: async e => {
		const { request, locals } = e,
			{ user } = await authorise(locals),
			{ user2 } = await getData(e)

		if (user.id == user2.id)
			throw error(400, "You can't friend/follow yourself")

		const data = await formData(request),
			{ action } = data

		try {
			actionFunctions?.[action](
				{
					user: `user:${user.id}`,
					user2: `user:${user2.id}`,
				},
				user,
			)
		} catch (e) {
			console.error(e)
			throw e
		}
	},
	rerender: async e => {
		const { locals, params, getClientAddress } = e
		await authorise(locals, 3)

		const { user2 } = await getData(e),
			limit = ratelimit({}, "rerender", getClientAddress, 60)
		if (limit) return fail(429, { msg: "Too many requests" })

		try {
			await requestRender("Avatar", parseInt(params.number), true)
			return {
				avatar: `/api/avatar/${user2.username}-body?r=${Math.random()}`,
			}
		} catch (e) {
			console.error(e)
			return fail(500, { msg: "Failed to request render" })
		}
	},
}
