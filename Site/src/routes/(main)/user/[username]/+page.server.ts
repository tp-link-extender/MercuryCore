import { error, fail } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import formData from "$lib/server/formData"
import requestRender from "$lib/server/requestRender"
import { db, Record, type RecordId } from "$lib/server/surreal"
import type { RequestEvent } from "./$types.d"
import acceptExistingQuery from "./acceptExisting.surql"
import alreadyFriendsQuery from "./alreadyFriends.surql"
import cancelQuery from "./cancel.surql"
import declineQuery from "./decline.surql"
import findUserQuery from "./findUser.surql"
import followQuery from "./follow.surql"
import incomingQuery from "./incoming.surql"
import requestQuery from "./request.surql"
import unfollowQuery from "./unfollow.surql"
import unfriendQuery from "./unfriend.surql"
import userQuery from "./user.surql"

interface User extends BasicUser {
	description: {
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
		id: string
		created: Date
		content: {
			id: string
			text: string
			updated: Date
		}[]
		visibility: string
	}[]
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const [[userExists]] = await db.query<User[][]>(userQuery, {
		...params,
		user: Record("user", user.id),
	})
	if (!userExists) error(404, "Not Found")

	return userExists
}

async function getData({ params }: RequestEvent) {
	const [[user2]] = await db.query<{ id: string }[][]>(findUserQuery, params)
	if (!user2) error(404, "User not found")

	return {
		id: user2.id,
		username: params.username,
	}
}

type ActionFunction = (
	params: {
		user: RecordId<"user">
		user2: RecordId<"user">
	},
	user: { id: string; username: string }
) => Promise<unknown>

const acceptExisting: ActionFunction = (params, user) =>
	db.query(
		// The direction of the ->friends relationship matches the direction of the previous ->request relationship.
		acceptExistingQuery,
		{
			...params,
			relativeId: user.id,
			note: `${user.username} is now friends with you!`,
		}
	)

async function getInteractData(e: RequestEvent) {
	const { user } = await authorise(e.locals)
	const user2 = await getData(e)

	if (user.id === user2.id) error(400, "You can't friend/follow yourself")

	return {
		user,
		params: {
			user: Record("user", user.id),
			user2: Record("user", user2.id),
		},
		data: await formData(e.request),
	}
}

async function rerender(e: RequestEvent) {
	await authorise(e.locals, 5)

	const user2 = await getData(e)

	try {
		await requestRender("Avatar", user2.id, user2.username, true)
		return {
			avatarBody: `/api/avatar/${e.params.username}-body?r=${Math.random()}`,
			avatar: `/api/avatar/${e.params.username}?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}
export const actions: import("./$types").Actions = { rerender }
actions.follow = async e => {
	const { user, params } = await getInteractData(e)
	await db.query(followQuery, {
		...params,
		relativeId: user.id,
		note: `${user.username} is now following you!`,
	})
}
actions.unfollow = async e => {
	const { params } = await getInteractData(e)
	await db.query(unfollowQuery, params)
}
actions.unfriend = async e => {
	const { params } = await getInteractData(e)
	await db.query(unfriendQuery, params)
}
actions.request = async e => {
	const { user, params } = await getInteractData(e)

	// Make sure users are not already friends
	const [alreadyFriends] = await db.query<boolean[]>(
		alreadyFriendsQuery,
		params
	)
	if (alreadyFriends) error(400, "Already friends")

	const [incoming] = await db.query<boolean[]>(incomingQuery, params)
	if (incoming) {
		await acceptExisting(params, user)
		return
	}

	await db.query(requestQuery, {
		...params,
		relativeId: user.id,
		note: `${user.username} has sent you a friend request.`,
	})
}
actions.cancel = async e => {
	const { params } = await getInteractData(e)
	await db.query(cancelQuery, params)
}
actions.decline = async e => {
	const { params } = await getInteractData(e)
	await db.query(declineQuery, params)
}
actions.accept = async e => {
	const { user, params } = await getInteractData(e)
	// Make sure an incoming request exists before accepting
	const [incoming] = await db.query<boolean[]>(incomingQuery, params)
	if (!incoming) error(400, "No friend request to accept")

	await acceptExisting(params, user)
}
