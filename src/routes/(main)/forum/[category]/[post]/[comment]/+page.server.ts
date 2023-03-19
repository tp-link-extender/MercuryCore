import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export async function load({ url, locals, params }) {
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
		include: {
			author: true,
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++)
		selectReplies.include.replies = JSON.parse(
			JSON.stringify(selectReplies)
		)

	const forumReplies = await prisma.forumReply.findUnique({
		where: {
			id: params.comment,
		},
		...selectReplies,
	})

	if (!forumReplies) throw error(404, "Reply not found")

	const { user } = await authorise(locals.validateUser)

	async function addLikes(reply: any) {
		const query = {
			user: user?.username,
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
			reply.replies = await Promise.all(
				reply.replies.map(async (reply: any) => await addLikes(reply))
			)

		return reply
	}

	const replies: any = await Promise.all(
		[forumReplies].map(async reply => await addLikes(reply))
	)

	return {
		replies,
		baseDepth: parseInt(url.searchParams.get("depth") as string),
		forumCategory: params.category,
		postId: params.post,
		author: post?.author.username,
	}
}
