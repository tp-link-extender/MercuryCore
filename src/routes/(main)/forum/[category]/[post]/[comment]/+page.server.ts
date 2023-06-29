import { actions as postActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

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
	const selectReplies: any = {
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
		selectReplies.select.replies = structuredClone(selectReplies)

	selectReplies.select.parentPost = {
		select: {
			forumCategoryName: true,
			title: true,
			id: true,
		},
	}

	const forumReplies = await prisma.forumReply.findUnique({
		where: {
			id: params.comment,
		},
		...selectReplies,
	})

	if (!forumReplies) throw error(404, "Reply not found")

	const { user } = await authorise(locals)

	async function addLikes(reply: any) {
		const query = {
			user: user.username,
			id: reply.id,
		}
		reply["likeCount"] = await roQuery(
			"forum",
			`RETURN SIZE((:User) -[:likes]-> (:Reply { name: $id }))`,
			query,
			true
		)
		reply["dislikeCount"] = await roQuery(
			"forum",
			`RETURN SIZE((:User) -[:dislikes]-> (:Reply { name: $id }))`,
			query,
			true
		)
		reply["likes"] = !!(await roQuery(
			"forum",
			`MATCH (:User { name: $user }) -[r:likes]-> (:Reply { name: $id }) RETURN r`,
			query
		))
		reply["dislikes"] = !!(await roQuery(
			"forum",
			`MATCH (:User { name: $user }) -[r:dislikes]-> (:Reply { name: $id }) RETURN r`,
			query
		))

		if (reply.replies)
			reply.replies = await Promise.all(reply.replies.map(addLikes))

		return reply
	}

	return {
		replies: await Promise.all([forumReplies].map(addLikes)),
		forumCategory: params.category,
		postId: params.post,
		author: post?.author.username,
	}
}

export const actions = postActions
