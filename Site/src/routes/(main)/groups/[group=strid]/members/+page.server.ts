// The members page for a group.

import { error } from "@sveltejs/kit"
import exclude from "$lib/server/exclude"
import { db, Record } from "$lib/server/surreal"
import membersQuery from "./members.surql"

type Group = {
	memberCount: number
	members: BasicUser[]
	name: string
}

export async function load({ params }) {
	exclude("Groups")
	const [[group]] = await db.query<Group[][]>(membersQuery, {
		group: Record("group", params.group),
	})
	if (!group) error(404, "Not Found")
	return group
}
