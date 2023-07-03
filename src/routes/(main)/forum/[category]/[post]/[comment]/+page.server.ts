import { actions as postActions } from "../+page.server"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import addLikes from "$lib/server/addLikes"
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

	const repliesWithLikes = await addLikes<typeof forumReplies>(
		"forum",
		"Reply",
		forumReplies,
		user.username
	)

	if (!repliesWithLikes) throw error(404, "Not found")

	return {
		replies: [repliesWithLikes],
		forumCategory: params.category,
		postId: params.post,
		author: post?.author.username,
	}
}

export const actions = postActions
