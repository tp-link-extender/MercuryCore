import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { getRequestEvent, query } from "$app/server"
import type { Comment } from "$lib/comment"
import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"

const schema = type("string")

export const getComment = query(schema, async id => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)

	const [[comment]] = await db.query<Comment[][]>(
		"fn::getComments($comment, 0, $user)",
		{
			comment: Record("comment", id),
			user: Record("user", user.id),
		}
	)
	if (!comment) error(404, "Comment not found")

	return comment
})
