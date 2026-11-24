import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { markNotificationRead } from "#lib/server/db/notifications.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	id: "string",
})

export const dismissForm = form(schema, async ({ id }) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	let updated: unknown[]
	try {
		updated = await markNotificationRead(id, Record("user", user.id))
	} catch {
		error(400)
	}
	if (updated.length === 0) error(404, "Notification not found")
})
