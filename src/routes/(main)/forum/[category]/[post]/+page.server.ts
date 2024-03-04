import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { error } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import { like } from "$lib/server/like"
import { recurse, type Replies } from "$lib/server/nestedReplies"
import type { RequestEvent } from "./$types"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTREPLIES = recurse(
	from => surql`
		(${from} <-replyToPost<-forumReply
		WHERE !->replyToReply
		ORDER BY pinned DESC, score DESC) AS replies`,
	// Make sure it's not a reply to another reply
	"replyToReply",
	"forumReply"
)

type ForumPost = {
	author: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
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
	if (!/^[0-9a-z]+$/.test(params.post)) error(400, "Invalid post id")

	const { user } = await authorise(locals)

	const forumPost = await squery<ForumPost>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, username FROM <-posted<-user)[0] AS author,
				count(<-likes) - count(<-dislikes) AS score,
				$user ∈ <-likes<-user.id AS likes,
				$user ∈ <-dislikes<-user.id AS dislikes,
				(->in->forumCategory)[0].name AS categoryName,

				${SELECTREPLIES}
			FROM $forumPost`,
		{
			forumPost: `forumPost:${params.post}`,
			user: `user:${user.id}`,
		}
	)

	if (!forumPost) error(404, "Not found")

	return {
		form: await superValidate(zod(schema)),
		...forumPost,
	}
}

async function findReply<T>(
	e: RequestEvent,
	permissionLevel?: number,
	input = surql`SELECT 1 FROM $forumReply`
) {
	const { locals, url } = e
	const { user } = await authorise(locals, permissionLevel)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing reply id")
	// Prevents incorrect ids erroring the Surreal query as well
	if (!/^[0-9a-z]+$/.test(id)) error(400, "Invalid reply id")

	const reply = await squery<T>(input, { forumReply: `forumReply:${id}` })
	if (!reply) error(404, "Reply not found")

	return { user, reply, id }
}

const pinThing = (pinned: boolean, thing: string) =>
	query(surql`UPDATE $thing SET pinned = $pinned`, { thing, pinned })

// wrapping this stuff in arrow functions just to prevent it from maybe returning god knows what to the client from an action
const pinReply = (pinned: boolean) => async (e: RequestEvent) => {
	await pinThing(pinned, `forumReply:${(await findReply(e, 4)).id}`)
}

const pinPost = (pinned: boolean) => async (e: RequestEvent) => {
	const { locals, url } = e
	await authorise(locals, 4)

	const id = url.searchParams.get("id")
	if (!id) error(400, "Missing post id")
	if (!/^[0-9a-z]+$/.test(id)) error(400, "Invalid post id")

	await pinThing(pinned, `forumPost:${id}`)
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)
		const form = await superValidate(request, zod(schema))
		if (!form.valid) return formError(form)

		const replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another reply

		const content = form.data.content.trim()
		if (!content)
			return formError(form, ["content"], ["Reply cannot be empty"])

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			error(400, "Invalid reply id")

		const limit = ratelimit(form, "forumReply", getClientAddress, 5)
		if (limit) return limit

		const replypost = await squery<{ authorId: string }>(
			surql`
				SELECT meta::id(<-posted[0]<-user[0].id) AS authorId
				FROM $replypostId
				WHERE visibility = "Visible"`,
			{
				replypostId: replyId
					? `forumReply:${replyId}`
					: `forumPost:${params.post}`,
			}
		)

		if (!replypost) error(404, `${replyId ? "Reply" : "Post"} not found`)

		const newReplyId = await squery<string>(surql`[fn::id()]`)

		await query(
			surql`
				LET $reply = CREATE $forumReply CONTENT {
					posted: time::now(),
					visibility: "Visible",
					content: [{
						text: $content,
						updated: time::now(),
					}],
				};
				RELATE $reply->replyToPost->$post;
				IF $replyId {
					RELATE $reply->replyToReply->$replyId;
				};
				RELATE $user->posted->$reply`,
			{
				content,
				user: `user:${user.id}`,
				forumReply: `forumReply:${newReplyId}`,
				post: `forumPost:${params.post}`,
				replyId: replyId ? `forumReply:${replyId}` : undefined,
			}
		)

		if (user.id !== replypost.authorId)
			await query(
				surql`
					RELATE $sender->notification->$receiver CONTENT {
						type: $type,
						time: time::now(),
						note: $note,
						relativeId: $relativeId,
						read: false,
					}`,
				{
					type: replyId ? "ForumReplyReply" : "ForumPostReply",
					sender: `user:${user.id}`,
					receiver: `user:${replypost.authorId}`,
					note: `${user.username} replied to your ${
						replyId ? "reply" : "post"
					}: ${content}`,
					relativeId: newReplyId,
				}
			)

		await like(user.id, `forumReply:${newReplyId}`)
	},
	delete: async e => {
		const { user, reply, id } = await findReply<{
			authorId: string
			visibility: string
		}>(
			e,
			undefined,
			surql`
				SELECT
					meta::id((<-posted<-user.id)[0]) AS authorId,
					visibility
				FROM $forumReply`
		)

		if (reply.authorId !== user.id)
			error(403, "You cannot delete someone else's reply")

		if (reply.visibility !== "Visible") error(400, "Reply already deleted")

		await query(
			surql`
				LET $poster = (SELECT <-posted<-user AS poster
				FROM $forumReply)[0].poster;

				UPDATE $forumReply SET content += [{
					text: "[deleted]",
					updated: time::now(),
				}];
				UPDATE $forumReply SET visibility = "Deleted"`,
			{ forumReply: `forumReply:${id}` }
		)
	},
	moderate: async e => {
		const { id } = await findReply(e, 4)

		await query(
			surql`
				BEGIN TRANSACTION;
				LET $reply = SELECT (<-posted<-user)[0] AS poster FROM $forumReply;
				LET $poster = $reply.poster;

				UPDATE $forumReply SET content += {
					text: "[removed]",
					updated: time::now(),
				};
				UPDATE $forumReply SET visibility = "Moderated";
				COMMIT TRANSACTION`,
			{ forumReply: `forumReply:${id}` }
		)
	},
	pin: pinReply(true),
	unpin: pinReply(false),
	pinpost: pinPost(true),
	unpinpost: pinPost(false),
	like: e =>
		categoryActions.like(e as unknown as import("../$types").RequestEvent),
}
