import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import catalogQuery from "./catalog.surql"

export type Asset = {
	name: string
	price: number
	id: number
}

export async function load({ url }) {
	const { page, checkPages } = pageQuery(url)
	// const type = url.searchParams.get("type") || ""
	// if (!intRegex.test(type)) error(400, "Invalid type parameter")

	const [assets, pages] = await db.query<[Asset[], number]>(catalogQuery, {
		page,
		// type: +type,
	})
	checkPages(pages)

	return { assets, pages }
}
