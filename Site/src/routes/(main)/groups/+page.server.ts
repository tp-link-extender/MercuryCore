import exclude from "$lib/server/exclude"
import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import groupsQuery from "./groups.surql"

export type Group = {
	id: string
	name: string
	memberCount: number
}

export async function load({ url }) {
	exclude("Groups")
	const { page, checkPages } = pageQuery(url)

	const [groups, pages] = await db.query<[Group[], number]>(groupsQuery, {
		page,
	})
	checkPages(pages)

	return { groups, pages }
}
