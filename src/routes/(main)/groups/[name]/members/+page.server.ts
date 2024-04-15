// The members page for a group.

import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

type Group = {
	memberCount: number
	members: BasicUser[]
	name: string
}

export async function load({ params }) {
	const group = await squery<Group>(import("./members.surql"), params)
	if (!group) error(404, "Not found")
	return group
}
