import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types"

type Group = {
	in: boolean
	memberCount: number
	name: string
	owner: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const group = await squery<Group>(
		surql`
			SELECT
				name,
				(SELECT number, status, username
				FROM <-owns<-user)[0] AS owner,
				count(<-member) AS memberCount,
				$user INSIDE <-member<-user.id AS in
				# [] AS places,
				# [] AS feed
			FROM group
			WHERE string::lowercase(name) = string::lowercase($name)`,
		{
			user: `user:${user.id}`,
			...params,
		}
	)

	if (!group) error(404, "Not found")

	return group
}

async function getData({ locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const group = await squery<{
		id: string
	}>(
		surql`
			SELECT id FROM group
			WHERE string::lowercase(name) = string::lowercase($name)`,
		params
	)

	if (!group) fail(400, { msg: "Group not found" })

	return {
		user: `user:${user.id}`,
		group: group.id,
	}
}

export const actions = {
	join: async e => {
		await query(
			surql`RELATE $user->member->$group SET time = time::now()`,
			await getData(e)
		)
	},
	leave: async e => {
		await query(
			surql`DELETE $user->member WHERE out = $group`,
			await getData(e)
		)
	},
}
