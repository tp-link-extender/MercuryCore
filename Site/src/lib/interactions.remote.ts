import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import acceptExistingQuery from "$lib/server/interactions/acceptExisting.surql"
import alreadyFriendsQuery from "$lib/server/interactions/alreadyFriends.surql"
import cancelQuery from "$lib/server/interactions/cancel.surql"
import declineQuery from "$lib/server/interactions/decline.surql"
import findUserQuery from "$lib/server/interactions/findUser.surql"
import followQuery from "$lib/server/interactions/follow.surql"
import incomingQuery from "$lib/server/interactions/incoming.surql"
import requestQuery from "$lib/server/interactions/request.surql"
import unfollowQuery from "$lib/server/interactions/unfollow.surql"
import unfriendQuery from "$lib/server/interactions/unfriend.surql"
import { ratelimitRemoteKey } from "$lib/server/ratelimit"
import requestRender from "$lib/server/requestRender"
import { db, Record, type RecordId } from "$lib/server/surreal"

// Friend and follow buttons are repeated per profile, so each is a `.for(username)` instance; the key arrives as `id`

const schema = type({
	id: "string",
})

// A type alias gives the implicit index signature SurrealDB's bindings need
// oxlint-disable-next-line typescript/consistent-type-definitions
type InteractionParams = {
	user: RecordId<"user">
	user2: RecordId<"user">
}

async function getInteractData(username: string) {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const [[user2]] = await db.query<{ id: string }[][]>(findUserQuery, {
		username,
	})
	if (!user2) error(404, "User not found")
	if (user.id === user2.id) error(400, "You can't friend/follow yourself")

	return {
		params: {
			user: Record("user", user.id),
			user2: Record("user", user2.id),
		} as InteractionParams,
		user,
		user2,
	}
}

type ActionFunction = (
	params: InteractionParams,
	user: { id: string; username: string }
) => Promise<unknown>

const acceptExisting: ActionFunction = (params, user) =>
	db.query(
		// The direction of the ->friends relationship matches the direction of the previous ->request relationship.
		acceptExistingQuery,
		{
			...params,
			note: `${user.username} is now friends with you!`,
			relativeId: user.id,
		}
	)

export const followForm = form(schema, async ({ id: username }, issues) => {
	const { user, params } = await getInteractData(username)

	// Following, unfollowing and following again sends a new notification each time
	const limit = ratelimitRemoteKey(issues, "follow", user.id, 600, 30)
	if (limit) return limit

	await db.query(followQuery, {
		...params,
		note: `${user.username} is now following you!`,
		relativeId: user.id,
	})
})

export const unfollowForm = form(schema, async ({ id: username }) => {
	const { params } = await getInteractData(username)
	await db.query(unfollowQuery, params)
})

export const unfriendForm = form(schema, async ({ id: username }) => {
	const { params } = await getInteractData(username)
	await db.query(unfriendQuery, params)
})

export const requestForm = form(schema, async ({ id: username }, issues) => {
	const { user, params } = await getInteractData(username)

	const limit = ratelimitRemoteKey(issues, "friendRequest", user.id, 600, 30)
	if (limit) return limit

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
		note: `${user.username} has sent you a friend request.`,
		relativeId: user.id,
	})
})

export const cancelForm = form(schema, async ({ id: username }) => {
	const { params } = await getInteractData(username)
	await db.query(cancelQuery, params)
})

export const declineForm = form(schema, async ({ id: username }) => {
	const { params } = await getInteractData(username)
	await db.query(declineQuery, params)
})

export const acceptForm = form(schema, async ({ id: username }) => {
	const { user, params } = await getInteractData(username)

	// Make sure an incoming request exists before accepting
	const [incoming] = await db.query<boolean[]>(incomingQuery, params)
	if (!incoming) error(400, "No friend request to accept")

	await acceptExisting(params, user)
})

export const rerenderForm = form(schema, async ({ id: username }) => {
	const { fetch: f, locals } = getRequestEvent()
	await authorise(locals, 5)

	const [[user2]] = await db.query<{ id: string }[][]>(findUserQuery, {
		username,
	})
	if (!user2) error(404, "User not found")

	try {
		await requestRender(f, "Avatar", user2.id, username, true)
		return {
			avatar: `/api/avatar/${username}?r=${Math.random()}`,
			avatarBody: `/api/avatar/${username}-body?r=${Math.random()}`,
		}
	} catch (err) {
		console.error(err)
		error(500, "Failed to request render")
	}
})
