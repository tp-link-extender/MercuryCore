// The friends, followers, and following pages for a user.

import { query, squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

const types = ["friends", "followers", "following"],
	usersQueries = {
		friends: surql`
			SELECT
				number,
				status,
				username
			FROM $user->friends->user OR $user<-friends<-user`,
		followers: surql`
			SELECT
				number,
				status,
				username
			FROM $user<-follows<-user`,
		following: surql`
			SELECT
				number,
				status,
				username
			FROM $user->follows->user`,
	},
	numberQueries = {
		friends: surql`count($user->friends->user) + count($user<-friends<-user)`,
		followers: surql`count($user<-follows<-user)`,
		following: surql`count($user->follows->user)`,
	}

export async function load({ params }) {
	if (!/^\d+$/.test(params.number))
		error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	if (params.f && !types.includes(params.f)) error(400, "Not found")

	const type = params.f as keyof typeof usersQueries,
		user = await squery<{
			id: string
			username: string
		}>(
			surql`
				SELECT id, username FROM user
				WHERE number = $number`,
			{ number }
		)

	if (!user) error(404, "Not found")

	return {
		type,
		username: user.username,
		users: await query<{
			number: number
			status: "Playing" | "Online" | "Offline"
			username: string
		}>(usersQueries[type], {
			user: user.id,
		}),
		number: (await query(numberQueries[type], {
			user: user.id,
		})) as unknown as number,
	}
}
