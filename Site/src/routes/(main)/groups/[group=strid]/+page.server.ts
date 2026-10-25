import { error, fail } from "@sveltejs/kit"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import {
	economyConnFailed,
	itemOwner,
	type OwnedUser,
} from "$lib/server/economy"
import exclude from "$lib/server/exclude"
import { db, find, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types.d"
import groupQuery from "./group.surql"
import joinQuery from "./join.surql"
import leaveQuery from "./leave.surql"

type Group = {
	id: string
	in: boolean
	memberCount: number
	name: string
	owner: OwnedUser | null
}

export async function load({ fetch: f, locals, params }) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const [[group]] = await db.query<Group[][]>(groupQuery, {
		user: Record("user", user.id),
		// ...params,
		group: Record("group", params.group),
	})
	if (!group) error(404, "Not Found")

	const owner = await itemOwner(f, new Econ.Group(params.group))
	if (!owner.ok) error(500, economyConnFailed)

	return { ...group, owner: owner.value }
}

async function getData({ locals, params }: RequestEvent) {
	exclude("Groups")
	const { user } = await authorise(locals)

	const groupExists = await find("group", params.group)
	if (!groupExists) fail(404, { msg: "Group not found" })

	return {
		user: Record("user", user.id),
		group: Record("group", params.group),
	}
}

export const actions: import("./$types").Actions = {}
actions.join = async e => {
	await db.query(joinQuery, await getData(e))
}
actions.leave = async e => {
	await db.query(leaveQuery, await getData(e))
}
