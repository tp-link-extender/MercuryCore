import { error, redirect } from "@sveltejs/kit"
import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { createComment } from "#lib/server/db/comments.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import exclude from "#lib/server/exclude.ts"
import filter from "#lib/server/filter.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"

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

	const [[getCategory]] = await dbQuery<{ id: string }[][]>(
		`
			SELECT record::id(id) AS id FROM forumCategory
			WHERE string::lowercase(name) = string::lowercase($category)`,
		{ category }
	)
	if (!getCategory) error(404, "Category not found")

	const newCommentId = await createComment({
		content: filter(unfiltered),
		type: ["forum", getCategory.id],
		user: Record("user", user.id),
	})

	redirect(302, `/comment/${newCommentId}`)
}) as ClientForm<typeof schema.infer>
