import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { commentTree } from "#lib/server/db/comments.ts"
import { Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import { getRequestEvent, query } from "$app/server"

const schema = type("string")

export const getComment = query(schema, async id => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const comment = await commentTree(id, Record("user", user.id))
	if (!comment) error(404, "Comment not found")

	if (comment.info && comment.info.type === "asset")
		comment.info.slug = encode(comment.info.asset)

	return comment
})
