import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import {
	acceptFriendRequest,
	alreadyFriends,
	cancelRequest,
	declineRequest,
	follow,
	hasIncomingRequest,
	type Notice,
	type Pair,
	requestFriend,
	unfollow,
	unfriend,
	userRecordOf,
} from "#lib/server/db/social.ts"
import { ratelimitRemoteKey } from "#lib/server/ratelimit.ts"
import { toRawId } from "#lib/server/recordId.ts"
import requestRender from "#lib/server/requestRender.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

// Friend and follow buttons are repeated per profile, so each is a `.for(username)` instance; the key arrives as `id`

const schema = type({
	id: "string",
})

async function getInteractData(username: string) {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const user2 = await userRecordOf(username)
	if (!user2) error(404, "User not found")
	if (user.id === toRawId(user2))
		error(400, "You can't friend/follow yourself")

	const pair: Pair = { user: Record("user", user.id), user2 }
	return { pair, user }
}

const acceptNotice = (user: { id: string; username: string }): Notice => ({
	note: `${user.username} is now friends with you!`,
	relativeId: user.id,
})

export const followForm = form(schema, async ({ id: username }, issues) => {
	const { user, pair } = await getInteractData(username)

	// Following, unfollowing and following again sends a new notification each time
	const limit = ratelimitRemoteKey(issues, "follow", user.id, 600, 30)
	if (limit) return limit

	await follow(pair, {
		note: `${user.username} is now following you!`,
		relativeId: user.id,
	})
})

export const unfollowForm = form(schema, async ({ id: username }) => {
	const { pair } = await getInteractData(username)
	await unfollow(pair)
})

export const unfriendForm = form(schema, async ({ id: username }) => {
	const { pair } = await getInteractData(username)
	await unfriend(pair)
})

export const requestForm = form(schema, async ({ id: username }, issues) => {
	const { user, pair } = await getInteractData(username)

	const limit = ratelimitRemoteKey(issues, "friendRequest", user.id, 600, 30)
	if (limit) return limit

	// Make sure users are not already friends
	if (await alreadyFriends(pair)) error(400, "Already friends")

	if (await hasIncomingRequest(pair)) {
		await acceptFriendRequest(pair, acceptNotice(user))
		return
	}

	await requestFriend(pair, {
		note: `${user.username} has sent you a friend request.`,
		relativeId: user.id,
	})
})

export const cancelForm = form(schema, async ({ id: username }) => {
	const { pair } = await getInteractData(username)
	await cancelRequest(pair)
})

export const declineForm = form(schema, async ({ id: username }) => {
	const { pair } = await getInteractData(username)
	await declineRequest(pair)
})

export const acceptForm = form(schema, async ({ id: username }) => {
	const { user, pair } = await getInteractData(username)

	// Make sure an incoming request exists before accepting
	if (!(await hasIncomingRequest(pair)))
		error(400, "No friend request to accept")

	await acceptFriendRequest(pair, acceptNotice(user))
})

export const rerenderForm = form(schema, async ({ id: username }) => {
	const { fetch: f, locals } = getRequestEvent()
	await authorise(locals, 5)

	const user2 = await userRecordOf(username)
	if (!user2) error(404, "User not found")

	try {
		await requestRender(f, "Avatar", toRawId(user2), username, true)
		return {
			avatar: `/api/avatar/${username}?r=${Math.random()}`,
			avatarBody: `/api/avatar/${username}-body?r=${Math.random()}`,
		}
	} catch (err) {
		console.error(err)
		error(500, "Failed to request render")
	}
})
