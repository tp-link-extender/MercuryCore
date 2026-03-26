import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import createCommentQuery from "$lib/server/createComment.surql"
import exclude from "$lib/server/exclude"
import filter from "$lib/server/filter"
import { ratelimitRemote } from "$lib/server/ratelimit"
import { db, Record } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"

const schema = type({
	// title: "1 <= string <= 50",
	content: "string <= 3000",
})

export const formData = form(schema, async ({ content }, issues) => {
	exclude("Forum")
	const { locals, url, getClientAddress } = getRequestEvent()
	const { user } = await authorise(locals)

	// const title = form.data.title.trim()
	// if (!title) return issues.title("Post must have a title")

	const unfiltered = content.trim()
	if (!unfiltered) return issues.content("Post must have content")

	const category = url.searchParams.get("category")
	if (!category) error(400, "Missing category")

	const limit = ratelimitRemote(issues, "comment", getClientAddress, 5)
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
}) as ClientForm<typeof schema.infer>
