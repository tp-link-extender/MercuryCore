import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import commentType from "#lib/server/commentType.ts"
import {
	createComment,
	removeComment,
	replyTargetOf,
	setPinned,
} from "#lib/server/db/comments.ts"
import { notify } from "#lib/server/db/notifications.ts"
import filter from "#lib/server/filter.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

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

		const target = await replyTargetOf(id)
		if (!target) error(404, "Comment not found")

		const { creatorId, type: commentTypes } = target
		const filtered = filter(content)

		const newCommentId = await createComment({
			comment: Record("comment", id),
			content: filtered,
			type: commentType(commentTypes, id),
			user: Record("user", user.id),
		})

		if (user.id !== creatorId)
			await notify(
				Record("user", user.id),
				Record("user", creatorId),
				"CommentReply",
				`${user.username} replied to your comment: ${filtered}`,
				newCommentId
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

	const ok = await setPinned(id, set === "true")
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

	const removed = await removeComment(id, Record("user", user.id), moderate)
	if (!removed) error(404, "Comment not found or already deleted")
})
