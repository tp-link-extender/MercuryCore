import { Record, equery } from "$lib/server/surreal"
import inventoryQuery from "./inventory.surql"

type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export default async function (id: string, query: string) {
	const [assets] = await equery<Asset[][]>(inventoryQuery, {
		query,
		user: Record("user", id),
	})
	return assets
}
