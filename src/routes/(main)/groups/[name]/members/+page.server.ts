// The member page for a group.

import { squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

type Group = {
	memberCount: number
	members: BasicUser[]
	name: string
}

export const load = async ({ params }) => {
	const group = await squery<Group>(
		surql`
			SELECT
				name,
				count(<-member) AS memberCount,
				(SELECT number, status, username
				FROM <-member<-user) AS members
			FROM group
			WHERE string::lowercase(name) = string::lowercase($name)`,
		params
	)

	if (!group) error(404, "Not found")

	return group
}
