import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import { error, fail, redirect } from "@sveltejs/kit"

export async function load({ url }) {
	const category = url.searchParams.get("category")
	if (!category) throw error(400, "Missing category")

	const getCategory = (
		await prisma.forumCategory.findMany({
			where: {
				name: {
					equals: category,
					mode: "insensitive",
				},
			},
		})
	)[0]

	if (!getCategory) throw error(404, "Category not found")

	return getCategory
}

export const actions = {
	default: async ({ url, locals, request, getClientAddress }) => {
		const limit = ratelimit("forumPost", getClientAddress, 30)
		if (limit) return limit

		const { user } = await authoriseUser(locals.validateUser)

		const data = await request.formData()
		const title = data.get("title") as string
		const content = data.get("content") as string
		const category = url.searchParams.get("category")

		if (!title || !content || !category)
			return fail(400, { msg: "Missing fields" })
		if (
			title.length < 5 ||
			title.length > 50 ||
			content.length < 5 ||
			content.length > 3000
		)
			return fail(400, { msg: "Invalid fields" })

		if (
			!(
				await prisma.forumCategory.findMany({
					where: {
						name: {
							equals: category,
							mode: "insensitive",
						},
					},
				})
			)[0]
		)
			return fail(400, { msg: "Invalid category" })

		const post = await prisma.forumPost.create({
			data: {
				id: await id(),
				title,
				content,
				authorId: user.userId,
				forumCategoryName: category,
			},
		})

		throw redirect(302, `/forum/${category}/${post.id}`)
	},
}
