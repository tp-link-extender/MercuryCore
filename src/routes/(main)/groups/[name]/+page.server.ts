import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surrealql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types"
import groupQuery from "./group.surql"

type Group = {
	in: boolean
	memberCount: number
	name: string
	owner: BasicUser
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const [[group]] = await equery<Group[][]>(groupQuery, {
		user: new RecordId("user", user.id),
		...params,
	})
	if (!group) error(404, "Not found")

	return group
}

async function getData({ locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const [[group]] = await equery<{ id: RecordId }[][]>(
		surrealql`
			SELECT id FROM group
			WHERE string::lowercase(name) = string::lowercase($name)`,
		params
	)

	if (!group) fail(400, { msg: "Group not found" })

	return {
		user: new RecordId("user", user.id),
		group: group.id,
	}
}

export const actions: import("./$types").Actions = {}
actions.join = async e => {
	await equery(
		surrealql`RELATE $user->member->$group SET time = time::now()`,
		await getData(e)
	)
}
actions.leave = async e => {
	await equery(
		surrealql`DELETE $user->member WHERE out = $group`,
		await getData(e)
	)
}
