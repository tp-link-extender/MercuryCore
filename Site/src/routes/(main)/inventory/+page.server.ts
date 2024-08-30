import { authorise } from "$lib/server/lucia"
import pageQuery from "$lib/server/pageQuery"
import { Record, equery } from "$lib/server/surreal.ts"
import inventoryQuery from "./inventory.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export type Q = [Asset[], number]

export async function load({ locals, url }) {
	const { user } = await authorise(locals)
	const { pq, checkPages } = pageQuery(url)

	const [assets, pages] = await equery<Q>(inventoryQuery, {
		user: Record("user", user.id),
		...pq,
	})
	checkPages(pages)

	return { assets }
}
