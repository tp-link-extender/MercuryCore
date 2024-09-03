import exclude from "$lib/server/exclude"
import pageQuery from "$lib/server/pageQuery"
import { equery } from "$lib/server/surreal"
import groupsQuery from "./groups.surql"

export type Group = {
	name: string
	memberCount: number
}

export async function load({ url }) {
	exclude("Groups")
	const { page, checkPages } = pageQuery(url)

	const [groups, pages] = await equery<[Group[], number]>(groupsQuery, {
		page,
	})
	checkPages(pages)

	return { groups, pages }
}
