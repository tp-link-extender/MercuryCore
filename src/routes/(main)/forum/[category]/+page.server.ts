import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import formData from "$lib/server/formData"
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
			include: {
				posts: {
					include: {
						author: true,
						content: {
							orderBy: {
								updated: "desc",
							},
							take: 1,
						},
						// _count: true,
					},
				},
			},
		})
	)[0]

	if (!category) throw error(404, "Not found")

	const { user } = await authorise(locals.validateUser)

	for (let post of category.posts as any) {
		post["likeCount"] = await roQuery(
			"forum",
			"RETURN SIZE((:User) -[:likes]-> (:Post { name: $id }))",
			{
				id: post.id,
			},
			true
		)
		post["dislikeCount"] = await roQuery(
			"forum",
			"RETURN SIZE((:User) -[:dislikes]-> (:Post { name: $id }))",
			{
				id: post.id,
			},
			true
		)
		post["likes"] = await roQuery(
			"forum",
			"MATCH (:User { name: $user }) -[r:likes]-> (:Post { name: $id }) RETURN r",
			{
				user: user.username,
				id: post.id,
			}
		)
		post["dislikes"] = await roQuery(
			"forum",
			"MATCH (:User { name: $user }) -[r:dislikes]-> (:Post { name: $id }) RETURN r",
			{
				user: user.username,
				id: post.id,
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
		const { user } = await authorise(locals.validateUser)
		const data = await formData(request)
		const action = data.action
		const id = data.id
		const replyId = data.replyId

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
			user: user.username,
			id: id || replyId,
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
