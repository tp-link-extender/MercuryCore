import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export async function load({ locals, params }) {
	const category = (
		await prisma.forumCategory.findMany({
			where: {
				name: {
					equals: params.category,
					mode: "insensitive",
				},
			},
			select: {
				name: true,
				description: true,
				posts: {
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
						_count: {
							select: {
								replies: true,
							},
						},
					},
				},
			},
		})
	)[0]

	if (!category) throw error(404, "Not found")

	const { user } = await authoriseUser(locals.validateUser)

	for (let post of category.posts as any) {
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
		post["likes"] = await roQuery(
			"forum",
			"MATCH (:User { name: $user }) -[r:likes]-> (:Post { name: $id }) RETURN r",
			{
				params: {
					user: user?.username,
					id: post.id,
				},
			}
		)
		post["dislikes"] = await roQuery(
			"forum",
			"MATCH (:User { name: $user }) -[r:dislikes]-> (:Post { name: $id }) RETURN r",
			{
				params: {
					user: user?.username,
					id: post.id,
				},
			}
		)
	}

	return category as typeof category & {
		posts: {
			likeCount: number
			dislikeCount: number
			likes: boolean
			dislikes: boolean
		}[]
	}
}

export const actions = {
	like: async ({ request, locals }) => {
		const { user } = await authoriseUser(locals.validateUser)
		const data = await request.formData()
		const action = data.get("action") as string
		const id = data.get("id") as string
		const replyId = data.get("replyId") as string

		if (
			(id &&
				!(await prisma.forumPost.findUnique({
					where: { id },
				}))) ||
			(replyId &&
				!(await prisma.forumReply.findUnique({
					where: { id: replyId },
				})))
		)
			throw error(404)

		const query = {
			params: {
				user: user.username,
				id: id || replyId,
			},
		}

		console.log("Action:", action)

		try {
			switch (action) {
				case "like":
					await Query(
						"forum",
						`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:${
								replyId ? "Reply" : "Post"
							} { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"forum",
						`
							MERGE (u:User { name: $user })
							MERGE (p:${replyId ? "Reply" : "Post"} { name: $id })
							MERGE (u) -[:likes]-> (p)
						`,
						query
					)
					break
				case "unlike":
					await Query(
						"forum",
						`
							MATCH (:User { name: $user }) -[r:likes]-> (:${
								replyId ? "Reply" : "Post"
							} { name: $id })
							DELETE r
						`,
						query
					)
					break
				case "dislike":
					await Query(
						"forum",
						`
							MATCH (:User { name: $user }) -[r:likes]-> (:${
								replyId ? "Reply" : "Post"
							} { name: $id })
							DELETE r
						`,
						query
					)
					await Query(
						"forum",
						`
							MERGE (u:User { name: $user })
							MERGE (p:${replyId ? "Reply" : "Post"} { name: $id })
							MERGE (u) -[:dislikes]-> (p)
						`,
						query
					)
					break
				case "undislike":
					await Query(
						"forum",
						`
							MATCH (:User { name: $user }) -[r:dislikes]-> (:${
								replyId ? "Reply" : "Post"
							} { name: $id })
							DELETE r
						`,
						query
					)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
