import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"

export async function load({ locals, params }) {
	// Since prisma does not yet support recursive copying, we have to do it manually
	const selectReplies: any = { // odd type errors in "replies: selectReplies" if not any
		include: {
			author: true,
			content: {
				orderBy: {
					updated: "desc",
				},
				take: 1,
			},
			replies: {},
		},
	}
	for (let i = 0; i < 9; i++)
		selectReplies.include.replies = JSON.parse(
			JSON.stringify(selectReplies)
		)

	const forumPost = await prisma.forumPost.findUnique({
		where: {
			id: params.post,
		},
		include: {
			author: true,
			forumCategory: true,
			replies: selectReplies,
			content: {
				orderBy: {
					updated: "desc",
				},
				take: 1,
			},
		},
	})

	if (!forumPost) throw error(404, "Not found")

	const { user } = await authorise(locals.validateUser)

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
		...post,
		...replies,
		baseDepth: 0,
	}
}

export const actions = {
	default: async ({ request, locals, params, getClientAddress }) => {
		const limit = ratelimit("forumReply", getClientAddress, 5)
		if (limit) return limit

		const { user } = await authorise(locals.validateUser)
		const data = await formData(request)
		const content = data.content
		if (!content || content.length > 1000 || content.length < 5)
			return fail(400)

		const replyId = data.replyId
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

		await prisma.forumReply.create({
			data: {
				id: await id(),
				authorId: user.id,
				content: {
					create: {
						text: content,
					},
				},
				...(replyId
					? { parentReplyId: replyId }
					: { parentPostId: params.post }),
			},
		})
	},
}
