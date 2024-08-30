import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal.ts"
import { json } from "@sveltejs/kit"
import type { Asset } from "../+page.server.ts"
import inventoryQuery from "../inventory.surql"

export async function GET({ locals, url }) {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.max(1, Math.round(+pageQ))

	const [assets] = await equery<Asset[][]>(inventoryQuery, {
		user: Record("user", user.id),
		query,
		page,
	})
	return json(assets)
}
