import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import like from "#lib/server/like/index.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"

const schema = type({
	action: type.enumerated("like", "unlike", "dislike", "undislike"),
	id: "string",
})

export const likeForm = form(schema, async ({ id, action }) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	await like(Record("user", user.id), Record("comment", id), action)
})
