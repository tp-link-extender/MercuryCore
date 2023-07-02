import { actions as categoryActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import { error } from "@sveltejs/kit"
import { NotificationType, Prisma } from "@prisma/client"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	content: z.string().min(5).max(1000),
	replyId: z.string().optional(),
})

export async function load({ locals, params }) {
	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies = {
		// odd type errors in "replies: selectReplies" if not any
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				orderBy: {
					updated: Prisma.SortOrder.desc,
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
		selectReplies.select.replies = structuredClone(selectReplies)

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

	async function addLikes(post2: typeof forumPost, reply = true) {
		if (!post2) return

		const post = post2 as typeof forumPost & {
			likeCount: number
			dislikeCount: number
			likes: boolean
			dislikes: boolean
		}

		const query = {
			user: user.username,
			id: post.id,
		}

		const type = reply ? "Reply" : "Post"

		const t = []
		if (post.replies) for (const r of post.replies) t.push(addLikes(r))
		;[post.likeCount, post.dislikeCount, post.likes, post.dislikes] =
			await Promise.all([
				roQuery(
					"forum",
					`RETURN SIZE((:User) -[:likes]-> (:${type} { name: $id }))`,
					query,
					true
				),
				roQuery(
					"forum",
					`RETURN SIZE((:User) -[:dislikes]-> (:${type} { name: $id }))`,
					query,
					true
				),
				roQuery(
					"forum",
					`MATCH (:User { name: $user }) -[r:likes]-> (:${type} { name: $id }) RETURN r`,
					query
				),
				roQuery(
					"forum",
					`MATCH (:User { name: $user }) -[r:dislikes]-> (:${type} { name: $id }) RETURN r`,
					query
				),
				...t,
			])

		post.likes = !!post.likes
		post.dislikes = !!post.dislikes

		if (!post.replies) return post

		return post
	}

	return {
		form: superValidate(schema),
		...(await addLikes(forumPost, false)),
		baseDepth: 0,
	}
}

export const actions = {
	reply: async ({ url, request, locals, params, getClientAddress }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "forumReply", getClientAddress, 5)
		if (limit) return limit

		const { content } = form.data
		const replyId = url.searchParams.get("rid")
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
	like: categoryActions.like,
}
