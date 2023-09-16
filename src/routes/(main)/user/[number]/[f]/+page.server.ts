// The friends, followers, and following pages for a user.

import surql from "$lib/surrealtag"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

const types = ["friends", "followers", "following"],
	usersQueries: { [k: string]: (id: string) => string } = {
		friends: id =>
			surql`SELECT number, username FROM
				user:${id}->friends->user OR user:${id}<-friends<-user`,
		followers: id =>
			surql`SELECT number, username FROM user:${id}<-follows<-user`,
		following: id =>
			surql`SELECT number, username FROM user:${id}->follows->user`,
	},
	numberQueries: { [k: string]: (id: string) => string } = {
		friends: id =>
			surql`count(user:${id}->friends->user) + count(user:${id}<-friends<-user)`,
		followers: id => surql`count(user:${id}<-follows<-user)`,
		following: id => surql`count(user:${id}->follows->user)`,
	}

export async function load({ params }) {
	if (!/^\d+$/.test(params.number))
		throw error(400, `Invalid user id: ${params.number}`)
	const number = parseInt(params.number)

	if (params.f && !types.includes(params.f)) throw error(400, "Not found")

	const type = params.f as "friends" | "followers" | "following",
		user = await prisma.authUser.findUnique({
			where: {
				number,
			},
		})

	if (!user) throw error(404, "Not found")

	return {
		type,
		username: user.username,
		users: squery(usersQueries[type](user.id)) as Promise<
			{
				number: number
				username: string
			}[]
		>,
		// number: roQuery("friends", numberQueries[type], query, true),
		number: squery(numberQueries[type](user.id)) as Promise<number>,
	}
}
