import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import formData from "$lib/server/formData"
import addLikes from "$lib/server/addLikes"
import { error } from "@sveltejs/kit"
import { likeSwitch } from "$lib/server/like.js"

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

				posts: {
					select: {
						id: true,
						title: true,
						posted: true,

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
						// _count: true,
					},
				},
			},
		})
	)[0]

	if (!category) throw error(404, "Not found")

	const { user } = await authorise(locals),
		fakeObject = {
			id: "", // id not needed
			replies: category.posts,
		}

	await addLikes<typeof fakeObject>(
		"forum",
		"Post",
		fakeObject,
		user.username,
	)

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
	like: async ({ request, locals, url }) => {
		const { user } = await authorise(locals),
			data = await formData(request),
			{ action } = data,
			id = url.searchParams.get("id"),
			replyId = url.searchParams.get("rid")

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

		await likeSwitch(
			action,
			user.username,
			replyId ? "reply" : "post",
			id || replyId || "",
		)
	},
}
