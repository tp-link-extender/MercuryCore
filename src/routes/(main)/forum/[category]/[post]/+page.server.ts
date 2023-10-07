import surql from "$lib/surrealtag"
import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import surreal, { squery } from "$lib/server/surreal"
import id, { valid } from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { error } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import { like } from "$lib/server/like"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

type Replies = {
	author: {
		number: number
		username: string
	}
	content: {
		id: string
		text: string
		updated: string
	}[]
	dislikeCount: number
	dislikes: boolean
	id: string
	likeCount: number
	likes: boolean
	parentPostId: string
	parentReplyId: null
	posted: string
	replies: Replies
	visibility: string
}[]

const SELECTFROM = () =>
	surql`
		SELECT
			*,
			(SELECT text, updated FROM $parent.content
			ORDER BY updated DESC) AS content,
			string::split(type::string(id), ":")[1] AS id,
			string::split(type::string($parent.id), ":")[1] AS parentPostId,
			NONE as parentReplyId,
			(SELECT number, username FROM <-posted<-user)[0] as author,
			
			count(<-likes) as likeCount,
			count(<-dislikes) as dislikeCount,
			($user ∈ <-likes<-user.id) as likes,
			($user ∈ <-dislikes<-user.id) as dislikes,

			# again #
		FROM`

function SELECTREPLIES() {
	let rep = surql`
		(${SELECTFROM()} <-replyToPost<-forumReply
		# Make sure it's not a reply to another reply
		WHERE !->replyToReply) as replies`

	for (let i = 0; i < 9; i++)
		rep = rep.replace(
			/# again #/g,
			surql`(${SELECTFROM()} <-replyToReply<-forumReply) AS replies`,
		)

	return rep.replace(/# again #/g, "[] AS replies")
}

export async function load({ locals, params }) {
	if (!valid(params.post)) throw error(400, "Invalid post id")

	const { user } = await authorise(locals),
		forumPost = (await squery(
			surql`
				SELECT
					*,
					string::split(type::string(id), ":")[1] AS id,
					(SELECT number, username FROM <-posted<-user)[0] as author,
					count(<-likes) as likeCount,
					count(<-dislikes) as dislikeCount,
					($user ∈ <-likes<-user.id) as likes,
					($user ∈ <-dislikes<-user.id) as dislikes,
					(->in->forumCategory)[0].name as categoryName,

					${SELECTREPLIES()}
				FROM $forumPost`,
			{
				forumPost: `forumPost:${params.post}`,
				user: `user:${user.id}`,
			},
		)) as {
			author: {
				number: number
				username: string
			}
			categoryName: string
			content: Array<{
				id: string
				text: any
				updated: string
			}>
			dislikeCount: number
			dislikes: boolean
			id: string
			likeCount: number
			likes: boolean
			posted: string
			replies: Replies
			title: string
			visibility: string
		}[]

	if (!forumPost[0]) throw error(404, "Not found")

	return {
		form: superValidate(schema),
		...forumPost[0],
		baseDepth: 0,
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
			replyId = url.searchParams.get("rid"),
			replypost = (
				(await squery(
					surql`
						SELECT 
							string::split(type::string(
								<-posted[0]<-user[0].id), ":")[1] AS authorId
						FROM $replypostId
						WHERE visibility = "Visible"`,
					{
						replypostId: replyId
							? `forumReply:${replyId}`
							: `forumPost:${params.post}`,
					},
				)) as {
					authorId: string
				}[]
			)[0]

		if (!replypost)
			throw error(404, `${replyId ? "Reply" : "Post"} not found`)

		const newReplyId = await id()

		await squery(
			surql`
				LET $textContent = CREATE textContent CONTENT {
					text: $content,
					updated: time::now(),
				};
				RELATE $user->wrote->$textContent;

				LET $reply = CREATE $forumReply CONTENT {
					posted: time::now(),
					visibility: "Visible",
					content: $textContent,
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
			await squery(
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
		if (!valid(id)) throw error(400, "Invalid reply id")
		// Prevents incorrect ids erroring the Surreal query as well

		const reply = (
			(await squery(
				surql`
					SELECT
						string::split(type::string((
							<-posted<-user.id)[0]), ":")[1] AS authorId,
						visibility
					FROM $forumReply`,
				{
					forumReply: `forumReply:${id}`,
				},
			)) as {
				authorId: string
				visibility: string
			}[]
		)[0]

		if (!reply) throw error(404, "Reply not found")

		if (reply.authorId != user.id)
			throw error(403, "You cannot delete someone else's reply")

		if (reply.visibility != "Visible")
			throw error(400, "Reply already deleted")

		await squery(
			surql`
				LET $poster = (SELECT
					<-posted<-user AS poster
				FROM $forumReply)[0].poster;
				LET $textContent = CREATE textContent CONTENT {
					text: "[deleted]",
					updated: time::now(),
				};
				RELATE $poster->wrote->$textContent;

				UPDATE $forumReply SET content += $textContent;
				UPDATE $forumReply SET visibility = "Deleted"`,
			{
				forumReply: `forumReply:${id}`,
			},
		)
	},
	moderate: async ({ url, locals }) => {
		await authorise(locals, 4)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")

		const findReply = (await surreal.select(`forumReply:${id}`))[0]

		if (!findReply) throw error(404, "Reply not found")

		await squery(
			surql`
				LET $reply = SELECT <-posted AS poster FROM $forumReply;
				LET $textContent = CREATE textContent CONTENT {
					text: "[removed]",
					updated: time::now(),
				};
				RELATE $reply.poster->wrote->$textContent;

				UPDATE $forumReply SET content += $textContent;
				UPDATE $forumReply SET visibility = "Moderated"`,
			{
				forumReply: `forumReply:${id}`,
			},
		)
	},
	like: categoryActions.like as any,
}
