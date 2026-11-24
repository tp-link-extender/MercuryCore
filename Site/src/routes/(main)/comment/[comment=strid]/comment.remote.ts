import { error } from "@sveltejs/kit"
import { type } from "arktype"
import type { Comment } from "#lib/comment.ts"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import { getRequestEvent, query } from "$app/server"

const schema = type("string")

export const getComment = query(schema, async id => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const [[comment]] = await dbQuery<Comment[][]>(
		"fn::getComments($comment, 0, $user)",
		{
			comment: Record("comment", id),
			user: Record("user", user.id),
		}
	)
	if (!comment) error(404, "Comment not found")

	if (comment.info && comment.info.type === "asset")
		comment.info.slug = encode(comment.info.asset)

	return comment
})
