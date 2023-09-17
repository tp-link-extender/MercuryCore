import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { like } from "$lib/server/like"
import { error, redirect } from "@sveltejs/kit"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	title: z.string().min(1).max(50),
	content: z.string().max(3000).optional(),
})

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
			select: {
				name: true,
			},
		})
	)[0]

	if (!getCategory) throw error(404, "Category not found")

	return {
		category: getCategory,
		form: superValidate(schema),
	}
}

export const actions = {
	default: async ({ request, locals, url, getClientAddress }) => {
		const { user } = await authorise(locals),
			form = await superValidate(request, schema)

		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "forumPost", getClientAddress, 30)
		if (limit) return limit

		const { title, content } = form.data,
			category = url.searchParams.get("category")

		if (
			!category ||
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
			throw error(400, "Invalid category")

		const postId = await id(),
			post = await prisma.forumPost.create({
				data: {
					id: postId,
					title,
					content: {
						create: {
							text: content || "",
						},
					},
					authorId: user.id,
					forumCategoryName: category,
				},
			})

		await squery(
			surql`
				LET $textContent = CREATE textContent CONTENT {
					text: $content,
					updated: time::now(),
				};
				RELATE user:${user.id}->wrote->$textContent;

				LET $post = CREATE forumPost:${postId} CONTENT {
					title: $title,
					posted: time::now(),
					visibility: "Visible",
				};
				RELATE $post->in->forumCategory:${category};
				RELATE user:${user.id}->posted->$post`,
			{
				title,
				content,
			},
		)

		await like(user.id, "forumPost", post.id)

		throw redirect(302, `/forum/${category}/${post.id}`)
	},
}
