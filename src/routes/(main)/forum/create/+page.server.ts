import cql from "$lib/cyphertag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query } from "$lib/server/redis"
import id from "$lib/server/id"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
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
			
		const post = await prisma.forumPost.create({
			data: {
				id: await id(),
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

		await Query(
			"forum",
			cql`
				MERGE (u:User { name: $user })
				MERGE (p:Post { name: $id })
				MERGE (u) -[:likes]-> (p)`,
			{ id: post.id, user: user.username },
		)

		throw redirect(302, `/forum/${category}/${post.id}`)
	},
}
