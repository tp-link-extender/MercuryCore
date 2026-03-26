import { error } from "@sveltejs/kit"
import exclude from "$lib/server/exclude"
import { db } from "$lib/server/surreal"

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
	}
}
