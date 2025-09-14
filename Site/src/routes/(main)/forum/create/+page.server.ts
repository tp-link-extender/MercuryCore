import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import exclude from "$lib/server/exclude"
import filter from "$lib/server/filter"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"

const schema = type({
	// title: "1 <= string <= 50",
	content: "(string <= 3000) | undefined",
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
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, url, getClientAddress }) => {
	exclude("Forum")
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	// const title = form.data.title.trim()
	// if (!title) return formError(form, ["title"], ["Post must have a title"])

	const unfiltered = form.data.content?.trim()
	if (!unfiltered)
		return formError(form, ["content"], ["Post must have content"])

	const category = url.searchParams.get("category")
	if (!category) error(400, "Missing category")

	const limit = ratelimit(form, "comment", getClientAddress, 5)
	if (limit) return limit

	const [[getCategory]] = await db.query<{ id: string }[][]>(
		`
			SELECT record::id(id) AS id FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase($category)`,
		{ category }
	)
	if (!getCategory) error(404, "Category not found")

	const [, newCommentId] = await db.query<string[]>(createCommentQuery, {
		content: filter(unfiltered),
		type: ["forum", getCategory.id],
		user: Record("user", user.id),
	})

	redirect(302, `/comment/${newCommentId}`)
}
