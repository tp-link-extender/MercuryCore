import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import { db, find, Record } from "$lib/server/surreal"
import joinQuery from "./join.surql"
import leaveQuery from "./leave.surql"

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
	await db.query(joinQuery, await getData(id))
})

export const leaveForm = form(schema, async ({ id }) => {
	await db.query(leaveQuery, await getData(id))
})
