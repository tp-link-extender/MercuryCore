// The friends, followers, and following pages for a user.

import surql from "$lib/surrealtag"
import { query, squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

const types = ["friends", "followers", "following"],
	usersQueries = {
		friends: surql`SELECT number, username FROM $user->friends->user OR $user<-friends<-user`,
		followers: surql`SELECT number, username FROM $user<-follows<-user`,
		following: surql`SELECT number, username FROM $user->follows->user`,
	},
	numberQueries = {
		friends: surql`count($user->friends->user) + count($user<-friends<-user)`,
		followers: surql`count($user<-follows<-user)`,
		following: surql`count($user->follows->user)`,
	}

export async function load({ params }) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	if (params.f && !types.includes(params.f)) throw error(400, "Not found")

	const type = params.f as keyof typeof usersQueries,
		user = (
			await query<{
				id: string
				username: string
			}>(
				surql`
					SELECT id, username FROM user
					WHERE number = $number`,
				{ number },
			)
		)[0]

	if (!user) throw error(404, "Not found")

	return {
		type,
		username: user.username,
		users: query<{
			number: number
			username: string
		}>(usersQueries[type], {
			user: user.id,
		}),
		number: squery<number>(numberQueries[type], {
			user: user.id,
		}),
	}
}
