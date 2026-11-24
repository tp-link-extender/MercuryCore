import { dbQuery } from "#lib/server/db/query.ts"
import exclude from "#lib/server/exclude.ts"
import forumQuery from "./forum.surql"

export interface PreviewPost {
	author: BasicUser
	created: Date
	currentContent: string
	id: string
}

interface Category {
	description: string
	latestPost: PreviewPost
	name: string
	postCount: number
}

export async function load() {
	exclude("Forum")
	const [categories] = await dbQuery<Category[][]>(forumQuery)
	return { categories }
}
