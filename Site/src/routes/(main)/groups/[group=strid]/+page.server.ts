import { error } from "@sveltejs/kit"
import { Group as EconGroup } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { groupOf } from "#lib/server/db/groups.ts"
import { economyConnFailed, itemOwner } from "#lib/server/economy.ts"
import exclude from "#lib/server/exclude.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const group = await groupOf(params.group, Record("user", user.id))
	if (!group) error(404, "Not Found")

	const owner = await itemOwner(f, new EconGroup(params.group))
	if (!owner.ok) error(500, economyConnFailed)

	return { ...group, owner: owner.value }
}
