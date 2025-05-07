import exclude from "$lib/server/exclude"
import { db } from "$lib/server/surreal"
import forumQuery from "./forum.surql"

export type PreviewPost = {
	id: string
	author: BasicUser
	created: Date
	currentContent: string
}

type Category = {
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
