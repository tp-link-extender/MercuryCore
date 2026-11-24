import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import acceptExistingQuery from "./social/acceptExisting.surql"
import alreadyFriendsQuery from "./social/alreadyFriends.surql"
import cancelQuery from "./social/cancel.surql"
import declineQuery from "./social/decline.surql"
import findUserQuery from "./social/findUser.surql"
import followQuery from "./social/follow.surql"
import followersQuery from "./social/followers.surql"
import followingQuery from "./social/following.surql"
import friendsQuery from "./social/friends.surql"
import incomingQuery from "./social/incoming.surql"
import requestQuery from "./social/request.surql"
import requestsQuery from "./social/requests.surql"
import unfollowQuery from "./social/unfollow.surql"
import unfriendQuery from "./social/unfriend.surql"
import userPageQuery from "./social/userPage.surql"

/** Two users, the one acting and the one they act on. */
// A type alias gives the implicit index signature SurrealDB's bindings need
// oxlint-disable-next-line typescript/consistent-type-definitions
export type Pair = {
	user: RecordId<"user">
	user2: RecordId<"user">
}

/** The notification an action sends, and the id it's about, such as the acting user's. */
export interface Notice {
	note: string
	relativeId: string
}

export type Relation = "followers" | "following" | "friends"

export interface UserPage extends BasicUser {
	comments: { content: string; created: Date }[]
	description: string | null
	follower: boolean
	followerCount: number
	following: boolean
	followingCount: number
	friendCount: number
	friends: boolean
	groups: { id: string; memberCount: number; name: string }[]
	id: string
	incomingRequest: boolean
	outgoingRequest: boolean
	permissionLevel: number
}

const relationQueries = Object.freeze({
	followers: followersQuery,
	following: followingQuery,
	friends: friendsQuery,
})

/**
 * Finds the record of the user with this username.
 * @returns The user, or undefined if there is no such user.
 */
export async function userRecordOf(
	username: string
): Promise<RecordId<"user"> | undefined> {
	const [[user]] = await dbQuery<{ id: string }[][]>(findUserQuery, {
		username,
	})
	return user ? Record("user", user.id) : undefined
}

/**
 * Finds the profile of a user, as seen by another user.
 * @returns The profile, or undefined if there is no such user.
 */
export async function userPageOf(
	username: string,
	viewer: RecordId<"user">
): Promise<UserPage | undefined> {
	const [[user]] = await dbQuery<UserPage[][]>(userPageQuery, {
		user: viewer,
		username,
	})
	return user
}

/** Lists the users in a relation to this user, with how many there are. */
export async function relationOf(
	relation: Relation,
	user: RecordId<"user">
): Promise<{ count: number; users: BasicUser[] }> {
	const [users, count] = await dbQuery<[BasicUser[], number]>(
		relationQueries[relation],
		{ id: user }
	)
	return { count, users }
}

/** Lists the users who have sent this user a friend request, one page at a time. */
export async function requestsOf(
	user: RecordId<"user">,
	page: number
): Promise<{ pages: number; users: BasicUser[] }> {
	const [users, pages] = await dbQuery<[BasicUser[], number]>(requestsQuery, {
		page,
		user,
	})
	return { pages, users }
}

export async function alreadyFriends(pair: Pair): Promise<boolean> {
	const [friends] = await dbQuery<boolean[]>(alreadyFriendsQuery, pair)
	return friends
}

/** Finds whether user2 has sent user a friend request. */
export async function hasIncomingRequest(pair: Pair): Promise<boolean> {
	const [incoming] = await dbQuery<boolean[]>(incomingQuery, pair)
	return incoming
}

export async function follow(pair: Pair, notice: Notice): Promise<void> {
	await dbQuery(followQuery, { ...pair, ...notice })
}

export async function unfollow(pair: Pair): Promise<void> {
	await dbQuery(unfollowQuery, pair)
}

export async function unfriend(pair: Pair): Promise<void> {
	await dbQuery(unfriendQuery, pair)
}

export async function requestFriend(pair: Pair, notice: Notice): Promise<void> {
	await dbQuery(requestQuery, { ...pair, ...notice })
}

/** Accepts the friend request user2 sent to user, which makes them friends and notifies user2. */
export async function acceptFriendRequest(
	pair: Pair,
	notice: Notice
): Promise<void> {
	// The direction of the ->friends relationship matches the direction of the previous ->request relationship.
	await dbQuery(acceptExistingQuery, { ...pair, ...notice })
}

export async function cancelRequest(pair: Pair): Promise<void> {
	await dbQuery(cancelQuery, pair)
}

export async function declineRequest(pair: Pair): Promise<void> {
	await dbQuery(declineQuery, pair)
}
