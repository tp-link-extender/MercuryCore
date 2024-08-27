import exclude from "$lib/server/exclude"
import { equery } from "$lib/server/surreal"
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
	const [categories] = await equery<Category[][]>(forumQuery)
	return { categories }
}
