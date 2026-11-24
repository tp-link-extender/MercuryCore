import { groupsPage } from "#lib/server/db/groups.ts"
import exclude from "#lib/server/exclude.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ url }: PageServerLoadEvent) {
	exclude("Groups")
	const { page, checkPages } = pageQuery(url)

	const { groups, pages } = await groupsPage(page)
	checkPages(pages)

	return { groups, pages }
}
