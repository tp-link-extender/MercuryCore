import type { PageServerLoad, Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
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
			replies: {
				select: {
					author: {
						select: {
							username: true,
							number: true,
							image: true,
						},
					},
					content: true,
					posted: true,
				},
			},
		},
	})

	if (!forumPost) throw error(404, "Not found")
	const post: typeof forumPost & { likeCount?: number; dislikeCount?: number; likes?: boolean; dislikes?: boolean } = forumPost

	const { user } = await authoriseUser(locals.validateUser)

	post["likeCount"] = await roQuery(
		"forum",
		"RETURN SIZE((:User) -[:likes]-> (:Post { name: $id }))",
		{
			params: {
				id: post.id,
			},
		},
		true
	)
	post["dislikeCount"] = await roQuery(
		"forum",
		"RETURN SIZE((:User) -[:dislikes]-> (:Post { name: $id }))",
		{
			params: {
				id: post.id,
			},
		},
		true
	)
	post["likes"] = await roQuery("forum", "MATCH (:User { name: $user }) -[r:likes]-> (:Post { name: $id }) RETURN r", {
		params: {
			user: user?.username,
			id: post.id,
		},
	})

	post["dislikes"] = await roQuery("forum", "MATCH (:User { name: $user }) -[r:dislikes]-> (:Post { name: $id }) RETURN r", {
		params: {
			user: user?.username,
			id: post.id,
		},
	})

	return post as typeof post & { likeCount: number; dislikeCount: number; likes: boolean; dislikes: boolean }
}

export const actions: Actions = {
	reply: async ({ request, locals, params }) => {
		const { user } = await authoriseUser(locals.validateUser)
		const data = await request.formData()
		const content = data.get("content") as string

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
	},
}
