import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import { error } from "@sveltejs/kit"
import { NotificationType } from "@prisma/client"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(5).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies: any = {
		// odd type errors in "replies: selectReplies" if not any
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			author: {
				select: {
					username: true,
					number: true,
					image: true,
				},
			},
			content: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++)
		selectReplies.select.replies = JSON.parse(JSON.stringify(selectReplies))

	const forumPost = await prisma.forumPost.findUnique({
		where: {
			id: params.post,
		},
		select: {
			id: true,
			title: true,
			posted: true,
			author: {
				select: {
					username: true,
					number: true,
					image: true,
				},
			},
			forumCategory: {
				select: {
					name: true,
				},
			},
			replies: {
				where: {
					parentReplyId: null,
				},
				...selectReplies,
			},
			content: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
		},
	})

	if (!forumPost) throw error(404, "Not found")

	const { user } = await authorise(locals)

	async function addLikes(post: any, reply = false) {
		const query = {
			user: user.username,
			id: post.id,
		}
		post["likeCount"] = await roQuery(
			"forum",
			`RETURN SIZE((:User) -[:likes]-> (:${
				reply ? "Reply" : "Post"
			} { name: $id }))`,
			query,
			true
		)
		post["dislikeCount"] = await roQuery(
			"forum",
			`RETURN SIZE((:User) -[:dislikes]-> (:${
				reply ? "Reply" : "Post"
			} { name: $id }))`,
			query,
			true
		)
		post["likes"] = !!(await roQuery(
			"forum",
			`MATCH (:User { name: $user }) -[r:likes]-> (:${
				reply ? "Reply" : "Post"
			} { name: $id }) RETURN r`,
			query
		))
		post["dislikes"] = !!(await roQuery(
			"forum",
			`MATCH (:User { name: $user }) -[r:dislikes]-> (:${
				reply ? "Reply" : "Post"
			} { name: $id }) RETURN r`,
			query
		))

		if (post.replies)
			post.replies = await Promise.all(
				post.replies.map(
					async (reply: any) => await addLikes(reply, true)
				)
			)

		return post
	}

	const replies: any = await Promise.all(
		forumPost.replies.map(async reply => await addLikes(reply, true))
	)
	const post: typeof forumPost & {
		likeCount: number
		dislikeCount: number
		likes: boolean
		dislikes: boolean
	} = await addLikes(forumPost)

	return {
		form: superValidate(schema),
		...post,
		...replies,
		baseDepth: 0,
	}
}

export const actions = {
	reply: async ({ request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "forumReply", getClientAddress, 5)
		// if (limit) return limit

		const { content, replyId } = form.data
		// If there is a replyId, it is a reply to another comment

		let replypost
		if (replyId)
			replypost = await prisma.forumReply.findUnique({
				where: { id: replyId },
			})
		else
			replypost = await prisma.forumPost.findUnique({
				where: { id: params.post },
			})
		if (!replypost) throw error(404)

		const newReplyId = await id()

		await prisma.forumReply.create({
			data: {
				id: newReplyId,
				authorId: user.id,
				content: {
					create: {
						text: content,
					},
				},
				parentPostId: params.post,
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
	},
	like: categoryActions.like as any
}
