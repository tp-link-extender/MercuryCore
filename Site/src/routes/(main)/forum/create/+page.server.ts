import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import exclude from "$lib/server/exclude"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	// title: z.string().min(1).max(50),
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
actions.default = async ({ locals, request, url, getClientAddress }) => {
	exclude("Forum")
	const { user } = await authorise(locals)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	// const title = form.data.title.trim()
	// if (!title) return formError(form, ["title"], ["Post must have a title"])

	const unfiltered = form.data.content?.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Post must have content"])

	const limit = ratelimit(form, "comment", getClientAddress, 30)
	if (limit) return limit

	const category = url.searchParams.get("category")
	if (!category) error(400, "Missing category")

	const [[getCategory]] = await db.query<{ id: string }[][]>(
		`
			SELECT record::id(id) AS id FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase($category)`,
		{ category }
	)
	if (!getCategory) error(404, "Category not found")

	const [, , , , newCommentId] = await db.query<string[]>(
		createCommentQuery,
		{
			user: Record("user", user.id),
			type: ["forum", getCategory.id],
			// title,
			content: filter(unfiltered),
		}
	)

	redirect(302, `/comment/${newCommentId}`)
}
