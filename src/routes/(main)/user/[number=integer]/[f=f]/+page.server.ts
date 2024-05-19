// The friends, followers, and following pages for a user.

import { type RecordId, equery, surrealql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

const usersQueries = Object.freeze({
	// "$id->friends->user OR $id<-friends<-user" doesn't work
	// "$id<->friends<->user" shows yourself in the list (twice)
	friends: surrealql`
		SELECT number, status, username
		FROM array::concat($id->friends->user, $id<-friends<-user)`,
	followers: surrealql`
		SELECT number, status, username FROM $id<-follows<-user`,
	following: surrealql`
		SELECT number, status, username FROM $id->follows->user`,
})
const numberQueries = Object.freeze({
	friends: surrealql`count($id->friends->user) + count($id<-friends<-user)`,
	followers: surrealql`count($id<-follows<-user)`,
	following: surrealql`count($id->follows->user)`,
})

export async function load({ params }) {
	const type = params.f as keyof typeof usersQueries
	const [[user]] = await equery<
		{
			id: RecordId<"user">
			username: string
		}[][]
	>(surrealql`SELECT id, username FROM user WHERE number = ${+params.number}`)
	if (!user) error(404, "Not found")

	const [users] = await equery<BasicUser[][]>(usersQueries[type], user)
	const [count] = await equery<number[]>(numberQueries[type], user)

	return {
		type,
		username: user.username,
		number: +params.number,
		users,
		count,
	}
}
