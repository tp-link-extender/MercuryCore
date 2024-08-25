import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Asset } from "../+page.server"
import avatarshopQuery from "../avatarshop.surql"

export async function GET({ url }) {
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.max(1, Math.round(+pageQ))

	const [assets] = await equery<Asset[][]>(avatarshopQuery, { query, page })
	return json(assets)
}
