import { equery } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import catalogQuery from "./catalog.surql"

export type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export const load = async ({ url }) => {
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) redirect(303, "/catalog?p=1")

	const [assets, pages] = await equery<[Asset[], number]>(catalogQuery, {
		page: 1,
	})
	if (page > pages) redirect(303, `/catalog?p=${pages}`)

	return { assets, pages }
}
