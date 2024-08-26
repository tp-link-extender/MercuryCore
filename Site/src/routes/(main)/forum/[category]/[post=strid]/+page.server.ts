import { idRegex } from "$lib/paramTests"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { like } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import { type Replies, recurse } from "$lib/server/nestedReplies"
import ratelimit from "$lib/server/ratelimit"
import { Record, type RecordId, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import { actions as categoryActions } from "../+page.server"
import type { RequestEvent } from "./$types.d.ts"
import createReplyQuery from "./createReply.surql"
import forumPostQuery from "./post.surql"
import updateVisibilityQuery from "./updateVisibility.surql"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTREPLIES = recurse(
	// Make sure it's not a reply to another reply
	`<-replyToPost<-forumReply
		WHERE !->replyToReply
		ORDER BY pinned DESC, score DESC`,
	"<-replyToReply<-forumReply"
)

type ForumPost = {
	author: BasicUser
	categoryName: string
	content: {
		text: string
		updated: string
	}[]
	dislikes: boolean
	id: string
	likes: boolean
	pinned: boolean
	posted: string
	replies: Replies
	score: number
	title: string
	visibility: string
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)

	const postQuery = forumPostQuery.replace("_SELECTREPLIES", SELECTREPLIES)
	const [[forumPost]] = await equery<ForumPost[][]>(postQuery, {
		forumPost: Record("forumPost", params.post),
		user: Record("user", user.id),
	})
	if (!forumPost) error(404, "Not found")

	return {
		form: await superValidate(zod(schema)),
		post: forumPost,
	}
}

async function findReply<T>(
	e: RequestEvent,
	permissionLevel?: number,
	input = "SELECT 1 FROM $forumReply"
) {
	const { locals, url } = e
	const { user } = await authorise(locals, permissionLevel)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing reply id")
	// Incorrect ids filtering is done with route matchers now

	const [[reply]] = await equery<T[][]>(input, {
		forumReply: Record("forumReply", id),
	})
	if (!reply) error(404, "Reply not found")

	return { user, reply, id }
}

const updateVisibility = (visibility: string, text: string, id: string) =>
	equery(updateVisibilityQuery, {
		forumReply: Record("forumReply", id),
		text,
		visibility,
	})

const pinThing = (pinned: boolean, thing: RecordId<string>) =>
	equery(surql`UPDATE $thing SET pinned = $pinned`, { thing, pinned })

// wrapping this stuff in arrow functions just to prevent it from maybe returning god knows what to the client from an action
const pinReply = (pinned: boolean) => async (e: RequestEvent) => {
	await pinThing(pinned, Record("forumReply", (await findReply(e, 4)).id))
}

const pinPost = (pinned: boolean) => async (e: RequestEvent) => {
	const { locals, url } = e
	await authorise(locals, 4)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing post id")
	if (!idRegex.test(id)) error(400, "Invalid post id")

	await pinThing(pinned, Record("forumPost", id))
}

export const actions: import("./$types").Actions = {}
actions.reply = async ({ url, request, locals, params, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	// If there is a replyId, it is a reply to another reply
	const replyId = url.searchParams.get("rid")
	if (replyId && !idRegex.test(replyId)) error(400, "Invalid reply id")

	const unfiltered = form.data.content.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Reply cannot be empty"])

	const limit = ratelimit(form, "forumReply", getClientAddress, 5)
	if (limit) return limit

	const replypostId = replyId
		? Record("forumReply", replyId)
		: Record("forumPost", params.post)
	const [[replypost]] = await equery<{ authorId: string }[][]>(
		surql`
			SELECT meta::id(<-created[0]<-user[0].id) AS authorId
			FROM ${replypostId}  WHERE visibility = "Visible"`
	)
	if (!replypost) error(404, `${replyId ? "Reply" : "Post"} not found`)

	const [newReplyId] = await equery<string[]>(surql`fn::id()`)

	await equery(createReplyQuery, {
		content: filter(unfiltered),
		user: Record("user", user.id),
		forumReply: Record("forumReply", newReplyId),
		post: Record("forumPost", params.post),
		replyId: replyId ? Record("forumReply", replyId) : undefined,
	})

	if (user.id !== replypost.authorId)
		await equery(
			surql`
				RELATE $sender->notification->$receiver CONTENT {
					type: ${replyId ? "ForumReplyReply" : "ForumPostReply"},
					time: time::now(),
					note: $note,
					relativeId: ${newReplyId},
					read: false,
				}`,
			{
				sender: Record("user", user.id),
				receiver: Record("user", replypost.authorId),
				note: `${user.username} replied to your ${
					replyId ? "reply" : "post"
				}: ${unfiltered}`,
			}
		)

	await like(user.id, Record("forumReply", newReplyId))
}
actions.delete = async e => {
	const { user, reply, id } = await findReply<{
		authorId: string
		visibility: string
	}>(
		e,
		undefined,
		`
			SELECT
				meta::id((<-created<-user.id)[0]) AS authorId,
				visibility
			FROM $forumReply`
	)

	if (reply.authorId !== user.id)
		error(403, "You cannot delete someone else's reply")

	if (reply.visibility !== "Visible") error(400, "Reply already deleted")

	await updateVisibility("Deleted", "[deleted]", id)
}
actions.moderate = async e => {
	await updateVisibility("Moderated", "[removed]", (await findReply(e, 4)).id)
}
actions.pin = pinReply(true)
actions.unpin = pinReply(false)
actions.pinpost = pinPost(true)
actions.unpinpost = pinPost(false)
actions.like = e =>
	categoryActions.like(e as unknown as import("../$types").RequestEvent)
