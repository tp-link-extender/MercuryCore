// The friends, followers, and following pages for a user.

import { error } from "@sveltejs/kit"
import { db, type RecordId } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import followersQuery from "./followers.surql"
import followingQuery from "./following.surql"
import friendsQuery from "./friends.surql"
import userQuery from "./user.surql"

// "$id->friends->user OR $id<-friends<-user" doesn't work
// "$id<->friends<->user" shows yourself in the list (twice)
const queries = Object.freeze({
	followers: followersQuery,
	following: followingQuery,
	friends: friendsQuery,
})

export async function load({ params }: PageServerLoadEvent) {
	const type = params.f as keyof typeof queries
	const [[user]] = await db.query<{ id: RecordId<"user"> }[][]>(
		userQuery,
		params
	)
	if (!user) error(404, "Not Found")

	const [users, count] = await db.query<BasicUser[][]>(queries[type], user)

	return {
		...params,
		count,
		f: params.f as keyof typeof queries,
		users,
	}
}
