import exclude from "$lib/server/exclude"
import { db } from "$lib/server/surreal"
import forumQuery from "./forum.surql"

type Category = {
	description: string
	name: string
	postCount: number
	latestPost: {
		author: BasicUser
		id: string
		posted: string
		title: string
	}
}

export async function load() {
	exclude("Forum")
	const [categories] = await db.query<Category[][]>(forumQuery)
	return { categories }
}
