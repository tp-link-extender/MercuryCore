import { equery, unpack } from "$lib/server/surreal"

const forumQuery = await unpack(import("./forum.surql"))

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
	const [categories] = await equery<Category[][]>(forumQuery)
	return { categories }
}
