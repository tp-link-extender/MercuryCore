import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import like from "$lib/server/like"
import { Record } from "$lib/server/surreal"

const schema = type({
	id: "string",
	action: type.enumerated("like", "unlike", "dislike", "undislike"),
})

export const likeForm = form(schema, async ({ id, action }) => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	await like(Record("user", user.id), Record("comment", id), action)
})
