import { db } from "$lib/server/surreal"
import assetsQuery from "./assets.surql"

type Asset = {
	id: number
    name: string
}

export async function load() {
	const [assets] = await db.query<Asset[][]>(assetsQuery)
	return { assets }
}
