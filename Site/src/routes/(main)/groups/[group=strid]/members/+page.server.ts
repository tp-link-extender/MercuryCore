// The members page for a group.

import { error } from "@sveltejs/kit"
import exclude from "#lib/server/exclude.ts"
import { db, Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import membersQuery from "./members.surql"

interface Group {
	memberCount: number
	members: BasicUser[]
	name: string
}

export async function load({ params }: PageServerLoadEvent) {
	exclude("Groups")
	const [[group]] = await db.query<Group[][]>(membersQuery, {
		group: Record("group", params.group),
	})
	if (!group) error(404, "Not Found")
	return group
}
