import type { PageServerLoad } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ url, locals, params }) => {
	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies = {
		select: {
			id: true,
			author: {
				select: {
					username: true,
					number: true,
					image: true,
				},
			},
			content: true,
			posted: true,
			parentReplyId: true,
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++) selectReplies.select.replies = JSON.parse(JSON.stringify(selectReplies))

	const forumReplies = await prisma.forumReply.findUnique({
		where: {
			id: params.comment,
		},
		...selectReplies,
	})

	if (!forumReplies) throw error(404, "Reply not found")

	const { user } = await authoriseUser(locals.validateUser)

	async function addLikes(reply: any) {
		const query = {
			params: {
				user: user?.username,
				id: reply.id,
			},
		}
		reply["likeCount"] = await roQuery("forum", `RETURN SIZE((:User) -[:likes]-> (:Reply { name: $id }))`, query, true)
		reply["dislikeCount"] = await roQuery("forum", `RETURN SIZE((:User) -[:dislikes]-> (:Reply { name: $id }))`, query, true)
		reply["likes"] = !!(await roQuery("forum", `MATCH (:User { name: $user }) -[r:likes]-> (:Reply { name: $id }) RETURN r`, query))
		reply["dislikes"] = !!(await roQuery("forum", `MATCH (:User { name: $user }) -[r:dislikes]-> (:Reply { name: $id }) RETURN r`, query))

		if (reply.replies) reply.replies = await Promise.all(reply.replies.map(async (reply: any) => await addLikes(reply)))

		return reply
	}

	const replies: any = await Promise.all([forumReplies].map(async reply => await addLikes(reply)))

	return {
		replies,
		baseDepth: parseInt(url.searchParams.get("depth")) || 0,
		forumCategory: params.category,
		postId: params.post,
	}
}
