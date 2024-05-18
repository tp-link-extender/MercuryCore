// The members page for a group.

import { equery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import membersQuery from "./members.surql"

type Group = {
	memberCount: number
	members: BasicUser[]
	name: string
}

export async function load({ params }) {
	const [[group]] = await equery<Group[][]>(membersQuery, params)
	if (!group) error(404, "Not found")
	return group
}
