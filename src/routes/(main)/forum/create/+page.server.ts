import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { squery } from "$lib/server/surreal"
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
	const categoryQuery = url.searchParams.get("category")
	if (!categoryQuery) throw error(400, "Missing category")

	const category = (
		(await squery(
			surql`
				SELECT name FROM forumCategory
				WHERE string::lowercase(name) = string::lowercase($categoryQuery)`,
			{ categoryQuery },
		)) as { name: string }[]
	)[0]

	if (!category) throw error(404, "Category not found")

	return {
		categoryName: category.name,
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
				(await squery(
					surql`
						SELECT * FROM forumCategory
						WHERE string::lowercase(name) = string::lowercase($category)`,
					{
						category,
					},
				)) as {}[]
			)[0]
		)
			throw error(400, "Invalid category")

		const postId = (await squery(surql`fn::id()`)) as string

		await squery(
			surql`
				LET $post = CREATE $postId CONTENT {
					title: $title,
					posted: time::now(),
					visibility: "Visible",
					content: [{
						text: $content,
						updated: time::now(),
					}],
				};
				RELATE $post->in->$category;
				RELATE $user->posted->$post`,
			{
				user: `user:${user.id}`,
				postId: `forumPost:${postId}`,
				category: `forumCategory:⟨${category}⟩`,
				title,
				content,
			},
		)

		await like(user.id, `forumPost:${postId}`)

		throw redirect(302, `/forum/${category}/${postId}`)
	},
}
