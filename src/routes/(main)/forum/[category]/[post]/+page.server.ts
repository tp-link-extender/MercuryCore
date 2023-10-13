import surql from "$lib/surrealtag"
import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import surreal, { query, squery } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { error } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import { like } from "$lib/server/like"
import { recurse, type Replies } from "./select"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

const SELECTREPLIES = recurse(
	from => surql`
		(${from} <-replyToPost<-forumReply
		# Make sure it's not a reply to another reply
		WHERE !->replyToReply) AS replies`,
)

export async function load({ locals, params }) {
	if (!/^[0-9a-z]+$/.test(params.post)) throw error(400, "Invalid post id")

	const { user } = await authorise(locals)

	const forumPost = await query<{
		author: {
			number: number
			username: string
		}
		categoryName: string
		content: {
			id: string
			text: any
			updated: string
		}[]
		dislikeCount: number
		dislikes: boolean
		id: string
		likeCount: number
		likes: boolean
		posted: string
		replies: Replies
		title: string
		visibility: string
	}>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, username FROM <-posted<-user)[0] AS author,
				count(<-likes) AS likeCount,
				count(<-dislikes) AS dislikeCount,
				$user ∈ <-likes<-user.id AS likes,
				$user ∈ <-dislikes<-user.id AS dislikes,
				(->in->forumCategory)[0].name AS categoryName,

				${SELECTREPLIES}
			FROM $forumPost`,
		{
			forumPost: `forumPost:${params.post}`,
			user: `user:${user.id}`,
		},
	)

	if (!forumPost[0]) throw error(404, "Not found")

	return {
		form: superValidate(schema),
		...forumPost[0],
	}
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals),
			form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "forumReply", getClientAddress, 5)
		if (limit) return limit

		const { content } = form.data,
			replyId = url.searchParams.get("rid")
		// If there is a replyId, it is a reply to another reply

		if (replyId && !/^[0-9a-z]+$/.test(replyId))
			throw error(400, "Invalid reply id")

		const replypost = await squery<{ authorId: string }>(
			surql`
				SELECT 
					meta::id(<-posted[0]<-user[0].id) AS authorId
				FROM $replypostId
				WHERE visibility = "Visible"`,
			{
				replypostId: replyId
					? `forumReply:${replyId}`
					: `forumPost:${params.post}`,
			},
		)

		if (!replypost)
			throw error(404, `${replyId ? "Reply" : "Post"} not found`)

		const newReplyId = await squery<string>(surql`fn::id()`)

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
			},
		)

		if (user.id != replypost.authorId)
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
				},
			)

		await like(user.id, `forumReply:${newReplyId}`)
	},
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")
		if (!/^[0-9a-z]+$/.test(id)) throw error(400, "Invalid reply id")
		// Prevents incorrect ids erroring the Surreal query as well

		const reply = await squery<{
			authorId: string
			visibility: string
		}>(
			surql`
				SELECT
					meta::id((-posted<-user.id)[0]) AS authorId
					visibility
				FROM $forumReply`,
			{ forumReply: `forumReply:${id}` },
		)

		if (!reply) throw error(404, "Reply not found")

		if (reply.authorId != user.id)
			throw error(403, "You cannot delete someone else's reply")

		if (reply.visibility != "Visible")
			throw error(400, "Reply already deleted")

		await query(
			surql`
				LET $poster = (SELECT
					<-posted<-user AS poster
				FROM $forumReply)[0].poster;

				UPDATE $forumReply SET content += [{
					text: "[deleted]",
					updated: time::now(),
				}];
				UPDATE $forumReply SET visibility = "Deleted"`,
			{ forumReply: `forumReply:${id}` },
		)
	},
	moderate: async ({ url, locals }) => {
		await authorise(locals, 4)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")
		if (!/^[0-9a-z]+$/.test(id)) throw error(400, "Invalid reply id")

		const findReply = (await surreal.select(`forumReply:${id}`))[0]

		if (!findReply) throw error(404, "Reply not found")

		await query(
			surql`
				BEGIN TRANSACTION;
				LET $reply = SELECT (<-posted<-user)[0] AS poster
					FROM $forumReply;
				LET $poster = $reply.poster;

				UPDATE $forumReply SET content += {
					text: "[removed]",
					updated: time::now(),
				};
				UPDATE $forumReply SET visibility = "Moderated";
				COMMIT TRANSACTION`,
			{ forumReply: `forumReply:${id}` },
		)
	},
	like: categoryActions.like as any,
}
