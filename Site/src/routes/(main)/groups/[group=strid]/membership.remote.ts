import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { joinGroup, leaveGroup } from "#lib/server/db/groups.ts"
import { find } from "#lib/server/db/records.ts"
import exclude from "#lib/server/exclude.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	id: "string",
})

async function getData(id: string) {
	exclude("Groups")
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const groupExists = await find("group", id)
	if (!groupExists) error(404, "Group not found")

	return {
		group: Record("group", id),
		user: Record("user", user.id),
	}
}

export const joinForm = form(schema, async ({ id }) => {
	const { group, user } = await getData(id)
	await joinGroup(group, user)
})

export const leaveForm = form(schema, async ({ id }) => {
	const { group, user } = await getData(id)
	await leaveGroup(group, user)
})
