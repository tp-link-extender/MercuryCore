import { error, fail } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
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
	owner: BasicUser
}

export async function load({ locals, params }) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const [[group]] = await db.query<Group[][]>(groupQuery, {
		user: Record("user", user.id),
		// ...params,
		group: Record("group", params.group),
	})
	if (!group) error(404, "Not Found")

	return group
}

async function getData({ locals, params }: RequestEvent) {
	exclude("Groups")
	const { user } = await authorise(locals)

	const { group } = params
	const groupExists = await find("group", group)
	if (!groupExists) fail(404, { msg: "Group not found" })

	return {
		user: Record("user", user.id),
		group,
	}
}

export const actions: import("./$types").Actions = {}
actions.join = async e => {
	await db.query(joinQuery, await getData(e))
}
actions.leave = async e => {
	await db.query(leaveQuery, await getData(e))
}
