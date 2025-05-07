import exclude from "$lib/server/exclude"
import { db } from "$lib/server/surreal"
import forumQuery from "./forum.surql"

type Category = {
	id: string
	description: string
	latestPost: {
		id: string
		author: BasicUser
		created: Date
		title: string
	}
	postCount: number
}

export async function load() {
	exclude("Forum")
	const [categories] = await db.query<Category[][]>(forumQuery)
	return { categories }
}
