import { actions as postActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"
import { Prisma } from "@prisma/client"

export async function load({ locals, params }) {
	const post = await prisma.forumPost.findUnique({
		where: {
			id: params.post,
		},
		select: {
			author: true,
		},
	})

	if (!post) throw error(404, "Post not found")

	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies = {
		select: {
			id: true,
			posted: true,
			parentReplyId: true,
			parentPost: {
				select: {
					forumCategoryName: true,
					title: true,
					id: true,
				},
			},
			author: {
				select: {
					username: true,
					number: true,
				},
			},
			content: {
				select: {
					text: true,
				},
				orderBy: {
					updated: Prisma.SortOrder.desc,
				},
				take: 1,
			},
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++) {
		const replies = structuredClone(selectReplies)
		selectReplies.select.replies = replies
	}

	const forumReplies = await prisma.forumReply.findUnique({
		where: {
			id: params.comment,
		},
		...selectReplies,
	})

	if (!forumReplies) throw error(404, "Reply not found")

	const { user } = await authorise(locals)

	async function addLikes(reply2: typeof forumReplies) {
		if (!reply2) return

		const reply = reply2 as typeof forumReplies & {
			likeCount: number
			dislikeCount: number
			likes: boolean
			dislikes: boolean
		}

		const query = {
			user: user.username,
			id: reply.id,
		}

		const t = []
		if (reply.replies) for (const r of reply.replies) t.push(addLikes(r))
		;[reply.likeCount, reply.dislikeCount, reply.likes, reply.dislikes] =
			await Promise.all([
				roQuery(
					"forum",
					"RETURN SIZE((:User) -[:likes]-> (:Reply { name: $id }))",
					query,
					true
				),
				roQuery(
					"forum",
					"RETURN SIZE((:User) -[:dislikes]-> (:Reply { name: $id }))",
					query,
					true
				),
				roQuery(
					"forum",
					"MATCH (:User { name: $user }) -[r:likes]-> (:Reply { name: $id }) RETURN r",
					query
				),
				roQuery(
					"forum",
					"MATCH (:User { name: $user }) -[r:dislikes]-> (:Reply { name: $id }) RETURN r",
					query
				),
				t,
			])

		reply.likes = !!reply.likes
		reply.dislikes = !!reply.dislikes

		return reply
	}

	return {
		replies: Promise.all([forumReplies].map(addLikes)),
		forumCategory: params.category,
		postId: params.post,
		author: post?.author.username,
	}
}

export const actions = postActions
