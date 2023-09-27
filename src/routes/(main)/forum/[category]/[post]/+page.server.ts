import surql from "$lib/surrealtag"
import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"
import { prisma } from "$lib/server/prisma"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { error } from "@sveltejs/kit"
import { NotificationType } from "@prisma/client"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import { like } from "$lib/server/like"

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	const { user } = await authorise(locals),
		forumPost = (await squery(
			surql`
				SELECT
					*,
					content[0] as content,
					(SELECT number, username FROM <-posted<-user)[0] as author,
					count(<-likes<-user) as likeCount,
					count(<-dislikes<-user) as dislikeCount,
					($user ∈ <-likes<-user.id) as likes,
					($user ∈ <-dislikes<-user.id) as dislikes,
					(->in->forumCategory)[0].name as categoryName,
					[] as replies
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
			content: {
				id: string
				text: string
				updated: string
			}[]
			replies: []
			categoryName: string
			dislikeCount: number
			dislikes: boolean
			id: string
			likeCount: number
			likes: boolean
			posted: string
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
			// If there is a replyId, it is a reply to another comment

			replypost = replyId
				? await prisma.forumReply.findUnique({
						where: { id: replyId },
				  })
				: await prisma.forumPost.findUnique({
						where: { id: params.post },
				  })

		if (!replypost) throw error(404)

		const newReplyId = await id()

		await squery(
			surql`
				LET $textContent = CREATE textContent CONTENT {
					text: "test delete l8r",
					updated: time::now(),
				};
				RELATE $user->wrote->$textContent;

				LET $reply = CREATE $forumReply CONTENT {
					posted: time::now(),
					visibility: "Visible",
					content: [$textContent],
				};
				RELATE $reply->replyToPost->$post;
				RELATE $user->posted->$reply`,
			{
				user: `user:${user.id}`,
				forumReply: `forumReply:${newReplyId}`,
				post: `forumPost:${params.post}`,
			},
		)

		await prisma.forumReply.create({
			data: {
				id: newReplyId,
				authorId: user.id,
				content: {
					create: {
						text: content,
					},
				},
				topParentId: params.post,
				parentReplyId: replyId,
			},
		})

		if (user.id != replypost.authorId)
			await prisma.notification.create({
				data: {
					type: replyId
						? NotificationType.ForumReplyReply
						: NotificationType.ForumPostReply,
					senderId: user.id,
					receiverId: replypost.authorId,
					note: `${user.username} replied to your ${
						replyId ? "reply" : "post"
					}: ${content}`,
					relativeId: newReplyId,
				},
			})

		await like(user.id, `forumReply:${newReplyId}`)
	},
	delete: async ({ url, locals }) => {
		const { user } = await authorise(locals),
			id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")

		const reply = await prisma.forumReply.findUnique({
			where: { id },
			select: {
				authorId: true,
				visibility: true,
			},
		})

		if (!reply) throw error(404, "Reply not found")

		if (reply.authorId != user.id)
			throw error(403, "You cannot delete someone else's reply")

		if (reply.visibility != "Visible")
			throw error(400, "Reply already deleted")

		await prisma.forumReply.update({
			where: { id },
			data: {
				visibility: "Deleted",
				content: {
					create: {
						text: "[deleted]",
					},
				},
			},
		})
	},
	moderate: async ({ url, locals }) => {
		await authorise(locals, 4)

		const id = url.searchParams.get("id")
		if (!id) throw error(400, "No reply id provided")

		try {
			await prisma.forumReply.update({
				where: { id },
				data: {
					visibility: "Moderated",
					content: {
						create: {
							text: "[removed]",
						},
					},
				},
			})
		} catch (e) {
			throw error(404, "Reply not found")
		}
	},
	like: categoryActions.like as any,
}
