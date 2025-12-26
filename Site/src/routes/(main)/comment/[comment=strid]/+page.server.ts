import { error } from "@sveltejs/kit"
import { type } from "arktype"
import type { Comment } from "$lib/comment"
import { authorise } from "$lib/server/auth"
import commentType from "$lib/server/commentType"
import createCommentQuery from "$lib/server/createComment.surql"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import { arktype, superValidate } from "$lib/server/validate"
import removeCommentQuery from "./removeComment.surql"

const schema = type({
	content: "1 <= string <= 1000",
	replyId: "string | undefined",
})

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

	return {
		comment,
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.comment = async ({ locals, params, request, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const unfiltered = form.data.content.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Reply cannot be empty"])

	const limit = ratelimit(form, "comment", getClientAddress, 5)
	if (limit) return limit

	const id = params.comment
	const comment = Record("comment", id)
	const [getComment] = await db.query<
		{ creatorId: string; type: string[] }[]
	>(
		`
			SELECT
				record::id(<-createdComment[0]<-user[0].id) AS creatorId,
				type
			FROM ONLY $comment WHERE visibility = "Visible"`,
		{ comment }
	)
	if (!getComment) error(404, "Comment not found")

	const { creatorId, type } = getComment
	const content = filter(unfiltered)

	const [, newCommentId] = await db.query<string[]>(createCommentQuery, {
		comment,
		content,
		type: commentType(type, id),
		user: Record("user", user.id),
	})

	if (user.id !== creatorId)
		await db.query(
			`fn::notify($sender, $receiver, "CommentReply", $note, $relativeId)`,
			{
				sender: Record("user", user.id),
				receiver: Record("user", creatorId),
				note: `${user.username} replied to your comment: ${content}`,
				relativeId: newCommentId,
			}
		)
}
actions.pin = async ({ locals, params, url, getClientAddress }) => {
	await authorise(locals, 4)

	const limit = ratelimit(null, "pin", getClientAddress, 1)
	if (limit) return limit

	const [[ok]] = await db.query<1[][]>(
		`
			UPDATE $comment WHERE type != ["status"]
				SET pinned = $pinned RETURN VALUE 1`,
		{
			comment: Record("comment", params.comment),
			pinned: url.searchParams.get("set") === "true",
		}
	)
	if (!ok) error(404, "Comment not found")
}
actions.delete = async ({ locals, params, url, getClientAddress }) => {
	const moderate = url.searchParams.get("action") === "moderate"

	const { user } = await authorise(locals, moderate ? 4 : 1)

	const limit = ratelimit(null, "delete", getClientAddress, 5)
	if (limit) return limit

	const [, , ok] = await db.query<1[][]>(removeCommentQuery, {
		comment: Record("comment", params.comment),
		user: Record("user", user.id),
		moderate,
	})
	if (!ok?.[0]) error(404, "Comment not found or already deleted")
}
