import { error } from "@sveltejs/kit"
import { Group as EconGroup } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import {
	economyConnFailed,
	itemOwner,
	type OwnedUser,
} from "#lib/server/economy.ts"
import exclude from "#lib/server/exclude.ts"
import { db, Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import groupQuery from "./group.surql"

interface Group {
	id: string
	in: boolean
	memberCount: number
	name: string
	owner: OwnedUser | null
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const [[group]] = await db.query<Group[][]>(groupQuery, {
		// ...params,
		group: Record("group", params.group),
		user: Record("user", user.id),
	})
	if (!group) error(404, "Not Found")

	const owner = await itemOwner(f, new EconGroup(params.group))
	if (!owner.ok) error(500, economyConnFailed)

	return { ...group, owner: owner.value }
}
