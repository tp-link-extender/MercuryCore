import { gamesPage } from "#lib/server/db/places.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ url }: PageServerLoadEvent) {
	const { page, checkPages } = pageQuery(url)

	const { places, pages } = await gamesPage(page)
	checkPages(pages)

	return { pages, places }
}
