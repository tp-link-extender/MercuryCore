// The members page for a group.

import exclude from "$lib/server/exclude"
import { db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import membersQuery from "./members.surql"

type Group = {
	memberCount: number
	members: BasicUser[]
	name: string
}

export async function load({ params }) {
	exclude("Groups")
	const [[group]] = await db.query<Group[][]>(membersQuery, params)
	if (!group) error(404, "Not Found")
	return group
}
