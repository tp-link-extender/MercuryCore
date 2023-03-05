import type { PageServerLoad, Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error, fail } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
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
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++) selectReplies.select.replies = JSON.parse(JSON.stringify(selectReplies))

	const forumPost = await prisma.forumPost.findUnique({
		where: {
			id: params.post,
		},
		select: {
			id: true,
			title: true,
			content: true,
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
			replies: selectReplies,
		},
	})

	if (!forumPost) throw error(404, "Not found")

	const { user } = await authoriseUser(locals.validateUser)

	async function addLikes(post: any, reply = false) {
		const query = {
			params: {
				user: user?.username,
				id: post.id,
			},
		}
		post["likeCount"] = await roQuery("forum", `RETURN SIZE((:User) -[:likes]-> (:${reply ? "Reply" : "Post"} { name: $id }))`, query, true)
		post["dislikeCount"] = await roQuery("forum", `RETURN SIZE((:User) -[:dislikes]-> (:${reply ? "Reply" : "Post"} { name: $id }))`, query, true)
		post["likes"] = !!(await roQuery("forum", `MATCH (:User { name: $user }) -[r:likes]-> (:${reply ? "Reply" : "Post"} { name: $id }) RETURN r`, query))
		post["dislikes"] = !!(await roQuery("forum", `MATCH (:User { name: $user }) -[r:dislikes]-> (:${reply ? "Reply" : "Post"} { name: $id }) RETURN r`, query))

		if (post.replies) post.replies = await Promise.all(post.replies.map(async (reply: any) => await addLikes(reply, true)))

		return post
	}

	const replies: any = await Promise.all(forumPost.replies.map(async reply => await addLikes(reply, true)))
	const post: typeof forumPost & { likeCount: number; dislikeCount: number; likes: boolean; dislikes: boolean } = await addLikes(forumPost)

	return {
		...post,
		...replies,
		baseDepth: 0,
	}
}

export const actions: Actions = {
	reply: async ({ request, locals, params }) => {
		const { user } = await authoriseUser(locals.validateUser)
		const data = await request.formData()
		const content = data.get("content") as string
		if (!content || content.length > 1000 || content.length < 15) return fail(400)

		const id = data.get("replyId") as string
		// If there is a replyId, it is a reply to another comment

		if (id) {
			const reply = await prisma.forumReply.findUnique({
				where: { id },
			})
			if (!reply) throw error(404)

			await prisma.forumReply.create({
				data: {
					authorId: user.userId,
					content,
					parentReplyId: id,
				},
			})
		} else {
			const post = await prisma.forumPost.findUnique({
				where: { id: params.post },
			})
			if (!post) throw error(404)

			await prisma.forumReply.create({
				data: {
					authorId: user.userId,
					content,
					parentPostId: params.post,
				},
			})
		}
	},
}
