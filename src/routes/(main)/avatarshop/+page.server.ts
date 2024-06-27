import { equery } from "$lib/server/surreal"
import avatarshopQuery from "./avatarshop.surql"

export type Asset = {
	name: string
	price: number
	id: number
	type: number
}

export const load = async () => {
	const [assets] = await equery<Asset[][]>(avatarshopQuery)
	return { assets }
}
