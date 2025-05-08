import type { Scored } from "$lib/like"
import { authorise } from "$lib/server/auth"
import commentType from "$lib/server/comentType"
import createCommentQuery from "$lib/server/createComment.surql"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { Record, db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

interface Comment extends Scored {
	id: string
	author: BasicUser
	content: {
		text: string
		updated: Date
	}[]
	comments: []
	created: Date
	parentId: string
	pinned: boolean
	type: string[]
	visibility: string
	info: {
		category?: string
		post?: string
	}
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const [[comment]] = await db.query<Comment[][]>(
		"fn::getComments($comment, 0, $user)",
		{
			comment: Record("comment", params.comment),
			user: Record("user", user.id),
		}
	)
	if (!comment) error(404, "Comment not found")

	console.log("info", comment.info)

	return {
		comment,
		form: await superValidate(zod(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.comment = async ({ request, locals, params, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const unfiltered = form.data.content.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Reply cannot be empty"])

	const limit = ratelimit(form, "comment", getClientAddress, 5)
	if (limit) return limit

	const comment = Record("comment", params.comment)
	const [getComment] = await db.query<{ authorId: string; type: string[] }[]>(
		`
			SELECT
				record::id(<-createdComment[0]<-user[0].id) AS authorId,
				type
			FROM ONLY $comment WHERE visibility = "Visible"`,
		{ comment }
	)
	if (!getComment) error(404, "Comment not found")

	const { authorId, type } = getComment
	const content = filter(unfiltered)

	const [, , , , newCommentId] = await db.query<string[]>(
		createCommentQuery,
		{
			comment,
			content,
			user: Record("user", user.id),
			type: commentType(type, params.comment),
		}
	)

	if (user.id !== authorId)
		await db.query(
			"fn::notify($sender, $receiver, $type, $note, $relativeId)",
			{
				sender: Record("user", user.id),
				receiver: Record("user", authorId),
				type: "CommentReply",
				note: `${user.username} replied to your comment: ${content}`,
				relativeId: newCommentId,
			}
		)
}
