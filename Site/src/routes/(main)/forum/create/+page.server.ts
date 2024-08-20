import formError from "$lib/server/formError"
import { like } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, equery, findWhere, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import createQuery from "./create.surql"

const schema = z.object({
	title: z.string().min(1).max(50),
	content: z.string().max(3000).optional(),
})

export async function load({ url }) {
	const categoryQuery = url.searchParams.get("category")
	if (!categoryQuery) error(400, "Missing category")

	const [[category]] = await equery<{ name: string }[][]>(
		surql`
			SELECT name FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase(${categoryQuery})`
	)

	if (!category) error(404, "Category not found")

	return {
		categoryName: category.name,
		form: await superValidate(zod(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, url, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const category = url.searchParams.get("category")

	const title = form.data.title.trim()
	if (!title) return formError(form, ["title"], ["Post must have a title"])
	const content = form.data.content?.trim()

	const limit = ratelimit(form, "forumPost", getClientAddress, 30)
	if (limit) return limit

	if (
		!category ||
		!(await findWhere(
			"forumCategory",
			"string::lowercase(name) = string::lowercase($category)",
			{ category }
		))
	)
		error(400, "Invalid category")

	const [newPostId] = await equery<string[]>(surql`fn::id()`)

	await equery(createQuery, {
		user: Record("user", user.id),
		postId: Record("forumPost", newPostId),
		category: Record("forumCategory", category),
		title,
		content,
	})

	await like(user.id, Record("forumPost", newPostId))

	redirect(302, `/forum/${category}/${newPostId}`)
}
