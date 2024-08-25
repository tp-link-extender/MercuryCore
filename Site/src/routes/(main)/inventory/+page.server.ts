import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal.ts"
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

	const [assets] = await equery<Asset[][]>(inventoryQuery, {
		query,
		user: Record("user", user.id),
	})
	return { query, assets }
}
