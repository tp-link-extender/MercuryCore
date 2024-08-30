import { authorise } from "$lib/server/lucia"
import pageQuery from "$lib/server/pageQuery"
import { Record, equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Asset, Q } from "../+page.server.ts"
import inventoryQuery from "../inventory.surql"

export async function GET({ locals, url }) {
	const { user } = await authorise(locals)
	const { pq, checkPages } = pageQuery(url)

	const [, assets, pages] = await equery<Q>(inventoryQuery, {
		user: Record("user", user.id),
		...pq,
	})
	checkPages(pages)

	return json(assets)
}
