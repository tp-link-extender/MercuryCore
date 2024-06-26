import formData from "$lib/server/formData"
import { authorise } from "$lib/server/lucia"
import requestRender from "$lib/server/requestRender"
import { RecordId, equery, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types.d.ts"
import userQuery from "./user.surql"

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
} & BasicUser

export async function load({ locals, params }) {
	const number = +params.number
	const { user } = await authorise(locals)
	const [[userExists]] = await equery<User[][]>(userQuery, {
		number,
		user: new RecordId("user", user.id),
	})

	if (!userExists) error(404, "Not found")
	return userExists
}

async function getData({ params }: RequestEvent) {
	const [[user2]] = await equery<
		{
			id: string
			username: string
		}[][]
	>(
		surql`
			SELECT meta::id(id) AS id, username
			FROM user WHERE number = ${+params.number}`
	)

	if (!user2) error(404, "User not found")
	return { user2 }
}

type ActionFunction = (
	params: {
		user: RecordId<"user">
		user2: RecordId<"user">
	},
	user: import("lucia").User
) => Promise<unknown>

const acceptExisting: ActionFunction = (params, user) =>
	equery(
		// The direction of the ->friends relationship matches the direction of the previous ->request relationship.
		surql`
			DELETE $user2->request WHERE out = $user;
			RELATE $user2->friends->$user SET time = time::now();
			RELATE $user->notification->$user2 CONTENT {
				type: "NewFriend",
				time: time::now(),
				note: $note,
				relativeId: ${user.id},
				read: false,
			}`,
		{
			...params,
			note: `${user.username} is now friends with you!`,
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
			user: new RecordId("user", user.id),
			user2: new RecordId("user", user2.id),
		},
		data: await formData(request),
	}
}

async function rerender(e: RequestEvent) {
	const { locals, params } = e
	await authorise(locals, 5)

	const { user2 } = await getData(e)

	try {
		await requestRender("Avatar", +params.number, true)
		return {
			avatarBody: `/api/avatar/${user2.username}-body?r=${Math.random()}`,
			avatar: `/api/avatar/${user2.username}?r=${Math.random()}`,
		}
	} catch (e) {
		console.error(e)
		return fail(500, { msg: "Failed to request render" })
	}
}
export const actions: import("./$types").Actions = { rerender }
actions.follow = async e => {
	const { user, params } = await getInteractData(e)
	await equery(
		surql`
			IF $user2 NOT IN $user->follows->user {
				RELATE $user->follows->$user2 SET time = time::now();
				RELATE $user->notification->$user2 CONTENT {
					type: "Follower",
					time: time::now(),
					note: $note,
					relativeId: ${user.id},
					read: false,
				}
			}`,
		{
			...params,
			note: `${user.username} is now following you!`,
		}
	)
}
actions.unfollow = async e => {
	const { params } = await getInteractData(e)
	await equery(
		surql`
			DELETE $user->follows WHERE out = $user2;
			DELETE $user->notification WHERE out = $user2
				AND type = "Follower"
				AND read = false`,
		params
	)
}
actions.unfriend = async e => {
	const { params } = await getInteractData(e)
	await equery(
		surql`
			DELETE $user<-friends WHERE in = $user2;
			DELETE $user->friends WHERE out = $user2;
			DELETE $user->notification WHERE out = $user2
				AND type = "NewFriend"
				AND read = false`,
		params
	)
}
actions.request = async e => {
	const { user, params } = await getInteractData(e)

	// Make sure users are not already friends
	const [alreadyFriends] = await equery<boolean[]>(
		surql`$user IN $user2->friends->user
			OR $user2 IN $user->friends->user`,
		params
	)
	if (alreadyFriends) error(400, "Already friends")

	const [incoming] = await equery<boolean[]>(
		surql`$user IN $user2->request->user`,
		params
	)
	if (incoming) {
		await acceptExisting(params, user)
		return
	}

	await equery(
		surql`
			RELATE $user->request->$user2 SET time = time::now();
			RELATE $user->notification->$user2 CONTENT {
				type: "FriendRequest",
				time: time::now(),
				note: $note,
				relativeId: ${user.id},
				read: false,
			}`,
		{
			...params,
			note: `${user.username} has sent you a friend request.`,
		}
	)
}
actions.cancel = async e => {
	const { params } = await getInteractData(e)
	await equery(
		surql`
			DELETE $user->request WHERE out = $user2;
			DELETE $user->notification WHERE out = $user2
				AND type = "FriendRequest"
				AND read = false`,
		params
	)
}
actions.decline = async e => {
	const { params } = await getInteractData(e)
	await equery(surql`DELETE $user2->request WHERE out = $user`, params)
}
actions.accept = async e => {
	const { user, params } = await getInteractData(e)
	// Make sure an incoming request exists before accepting
	const [incoming] = await equery<boolean[]>(
		surql`$user IN $user2->request->user`,
		params
	)
	if (!incoming) error(400, "No friend request to accept")

	await acceptExisting(params, user)
}
