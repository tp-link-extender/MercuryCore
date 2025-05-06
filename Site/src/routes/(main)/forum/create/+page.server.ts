import exclude from "$lib/server/exclude"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import { like } from "$lib/server/like"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, db, findWhere, incrementId } from "$lib/server/surreal"
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
	exclude("Forum")
	const categoryParam = url.searchParams.get("category")
	if (!categoryParam) error(400, "Missing category")

	const [[category]] = await db.query<{ name: string }[][]>(
		`
			SELECT name FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase($categoryParam)`,
		{ categoryParam }
	)
	if (!category) error(404, "Category not found")

	return {
		categoryName: category.name,
		form: await superValidate(zod(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, url, getClientAddress }) => {
	exclude("Forum")
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const title = form.data.title.trim()
	if (!title) return formError(form, ["title"], ["Post must have a title"])

	const limit = ratelimit(form, "forumPost", getClientAddress, 30)
	if (limit) return limit

	const category = url.searchParams.get("category")
	if (
		!category ||
		!(await findWhere(
			"forumCategory",
			"string::lowercase(name) = string::lowercase($category)",
			{ category }
		))
	)
		error(400, "Invalid category")

	const unfiltered = form.data.content?.trim()

	const newPost = await db.query<string[]>(createQuery, {
		user: Record("user", user.id),
		category: Record("forumCategory", category),
		title,
		content: unfiltered ? filter(unfiltered) : undefined,
	})
	const newPostId = newPost[3] // let's hear it for newPost

	await like(user.id, Record("forumPost", newPostId))

	redirect(302, `/forum/${category}/${newPostId}`)
}
