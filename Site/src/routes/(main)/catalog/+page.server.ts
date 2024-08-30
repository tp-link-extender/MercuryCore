import pageQuery from "$lib/server/pageQuery"
import { equery } from "$lib/server/surreal"
import catalogQuery from "./catalog.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export const load = async ({ url }) => {
	const { page, checkPages } = pageQuery(url)

	const [assets, pages] = await equery<[Asset[], number]>(catalogQuery, {
		page,
	})
	checkPages(pages)

	return { assets, pages }
}
