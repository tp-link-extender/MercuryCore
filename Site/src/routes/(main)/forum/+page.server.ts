import exclude from "#lib/server/exclude.ts"
import { db } from "#lib/server/surreal.ts"
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
	const [categories] = await db.query<Category[][]>(forumQuery)
	return { categories }
}
