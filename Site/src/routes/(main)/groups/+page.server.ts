import { dbQuery } from "#lib/server/db/query.ts"
import exclude from "#lib/server/exclude.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import type { PageServerLoadEvent } from "./$types"
import groupsQuery from "./groups.surql"

export interface Group {
	id: string
	memberCount: number
	name: string
}

export async function load({ url }: PageServerLoadEvent) {
	exclude("Groups")
	const { page, checkPages } = pageQuery(url)

	const [groups, pages] = await dbQuery<[Group[], number]>(groupsQuery, {
		page,
	})
	checkPages(pages)

	return { groups, pages }
}
