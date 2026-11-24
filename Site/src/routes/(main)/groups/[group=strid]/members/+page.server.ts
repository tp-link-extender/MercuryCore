// The members page for a group.

import { error } from "@sveltejs/kit"
import { groupMembersOf } from "#lib/server/db/groups.ts"
import exclude from "#lib/server/exclude.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ params }: PageServerLoadEvent) {
	exclude("Groups")
	const group = await groupMembersOf(params.group)
	if (!group) error(404, "Not Found")
	return group
}
