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

	try {
		await db.query(readQuery, {
			notification: Record("notification", id),
			user: Record("user", user.id),
		})
	} catch {
		error(400)
	}
})
