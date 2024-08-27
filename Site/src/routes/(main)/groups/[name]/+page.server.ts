import exclude from "$lib/server/exclude"
import { authorise } from "$lib/server/lucia"
import { Record, type RecordId, equery, surql } from "$lib/server/surreal"
import { error, fail } from "@sveltejs/kit"
import type { RequestEvent } from "./$types.d.ts"
import groupQuery from "./group.surql"

type Group = {
	in: boolean
	memberCount: number
	name: string
	owner: BasicUser
}

export async function load({ locals, params }) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const [[group]] = await equery<Group[][]>(groupQuery, {
		user: Record("user", user.id),
		...params,
	})
	if (!group) error(404, "Not found")

	return group
}

async function getData({ locals, params }: RequestEvent) {
	exclude("Groups")
	const { user } = await authorise(locals)
	const [[group]] = await equery<{ id: RecordId }[][]>(
		surql`
			SELECT id FROM group
			WHERE string::lowercase(name) = string::lowercase($name)`,
		params
	)

	if (!group) fail(400, { msg: "Group not found" })

	return {
		user: Record("user", user.id),
		group: group.id,
	}
}

export const actions: import("./$types").Actions = {}
actions.join = async e => {
	await equery(
		surql`RELATE $user->member->$group SET time = time::now()`,
		await getData(e)
	)
}
actions.leave = async e => {
	await equery(
		surql`DELETE $user->member WHERE out = $group`,
		await getData(e)
	)
}
