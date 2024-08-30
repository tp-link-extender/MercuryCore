import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal.ts"
import { redirect } from "@sveltejs/kit"
import inventoryQuery from "./inventory.surql"

export type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export async function load({ locals, url }) {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) {
		url.searchParams.set("p", "1")
		redirect(303, url)
	}

	const [assets, pages] = await equery<[Asset[], number]>(inventoryQuery, {
		user: Record("user", user.id),
		query,
		page,
	})
	if (page > pages) {
		url.searchParams.set("p", pages.toString())
		redirect(303, url)
	}

	return { query, assets }
}
