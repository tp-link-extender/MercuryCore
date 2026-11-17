import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "#lib/server/auth.ts"
import commentType from "#lib/server/commentType.ts"
import createCommentQuery from "#lib/server/createComment.surql"
import filter from "#lib/server/filter.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import removeCommentQuery from "#lib/server/removeComment.surql"
import { db, Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"

// Comment reply, pin and delete forms, shared by the comment page and the comment lists on asset and forum pages

const replySchema = type({
	content: "1 <= string <= 1000",
	id: "string",
})

export const replyForm: ClientForm<typeof replySchema.infer> = form(
	replySchema,
	async ({ content: unfiltered, id }, issues) => {
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		const content = unfiltered.trim()
		if (!content) return issues.content("Reply cannot be empty")

		const limit = ratelimitRemote(issues, "comment", getClientAddress, 5)
		if (limit) return limit

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

		const { creatorId, type: commentTypes } = getComment
		const filtered = filter(content)

		const [, newCommentId] = await db.query<string[]>(createCommentQuery, {
			comment,
			content: filtered,
			type: commentType(commentTypes, id),
			user: Record("user", user.id),
		})

		if (user.id !== creatorId)
			await db.query(
				`fn::notify($sender, $receiver, "CommentReply", $note, $relativeId)`,
				{
					note: `${user.username} replied to your comment: ${filtered}`,
					receiver: Record("user", creatorId),
					relativeId: newCommentId,
					sender: Record("user", user.id),
				}
			)
	}
)

const pinSchema = type({
	id: "string",
	set: "string",
})

export const pinForm = form(pinSchema, async ({ id, set }, issues) => {
	const { locals, getClientAddress } = getRequestEvent()
	await authorise(locals, 4)

	const limit = ratelimitRemote(issues, "pin", getClientAddress, 1)
	if (limit) return limit

	const [[ok]] = await db.query<1[][]>(
		`
			UPDATE $comment SET pinned = $pinned
				WHERE type != ["status"] RETURN VALUE 1`,
		{
			comment: Record("comment", id),
			pinned: set === "true",
		}
	)
	if (!ok) error(404, "Comment not found")
})

// "remove" is a moderation action, "delete" a user deleting their own comment
const deleteSchema = type({
	action: type.enumerated("delete", "remove"),
	id: "string",
})

export const deleteForm = form(deleteSchema, async ({ action, id }, issues) => {
	const moderate = action === "remove"
	const { locals, getClientAddress } = getRequestEvent()
	const { user } = await authorise(locals, moderate ? 4 : 1)

	const limit = ratelimitRemote(issues, "delete", getClientAddress, 5)
	if (limit) return limit

	const deleted = await db.query<1[][]>(removeCommentQuery, {
		comment: Record("comment", id),
		moderate,
		user: Record("user", user.id),
	})
	if (!deleted[2]?.[0]) error(404, "Comment not found or already deleted")
})
