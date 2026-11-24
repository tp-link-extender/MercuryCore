import { error } from "@sveltejs/kit"
import { categoryNameOf } from "#lib/server/db/forums.ts"
import exclude from "#lib/server/exclude.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ url }: PageServerLoadEvent) {
	exclude("Forum")
	const categoryParam = url.searchParams.get("category")
	if (!categoryParam) error(400, "Missing category")

	const categoryName = await categoryNameOf(categoryParam)
	if (!categoryName) error(404, "Category not found")

	return {
		categoryName,
	}
}
