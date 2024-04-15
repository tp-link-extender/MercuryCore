import { query } from "$lib/server/surreal"

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

export const load = async () => ({
	categories: await query<Category>(import("./forum.surql")),
})
