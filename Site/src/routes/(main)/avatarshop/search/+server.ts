import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Asset } from "../+page.server"
import avatarshopQuery from "../avatarshop.surql"

export async function GET({ url }) {
	const query = url.searchParams.get("q")?.trim() as string
	const [assets] = await equery<Asset[][]>(avatarshopQuery, { query })
	return json(assets)
}
