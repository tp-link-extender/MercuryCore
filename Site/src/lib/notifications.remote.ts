import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import readQuery from "#lib/server/readNotification.surql"
import { db, Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	id: "string",
})

export const dismissForm = form(schema, async ({ id }) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	let updated: unknown[]
	try {
		const [rows] = await db.query<unknown[][]>(readQuery, {
			notification: Record("notification", id),
			user: Record("user", user.id),
		})
		updated = rows
	} catch {
		error(400)
	}
	if (updated.length === 0) error(404, "Notification not found")
})
