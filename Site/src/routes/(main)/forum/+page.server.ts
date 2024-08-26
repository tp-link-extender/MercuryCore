import config from "$lib/server/config"
import { equery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
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
	const [categories] = await equery<Category[][]>(forumQuery)
	return { categories }
}
