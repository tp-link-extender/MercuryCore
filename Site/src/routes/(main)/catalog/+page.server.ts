import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import catalogQuery from "./catalog.surql"

export type Asset = {
	name: string
	price: number
	id: string
	type: number
}

export async function load({ url }) {
	const { page, checkPages } = pageQuery(url)

	const [assets, pages] = await db.query<[Asset[], number]>(catalogQuery, {
		page,
	})
	checkPages(pages)

	return { assets, pages }
}
