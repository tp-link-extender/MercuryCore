import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal.ts"
import { json } from "@sveltejs/kit"
import type { Asset } from "../+page.server.ts"
import inventoryQuery from "../inventory.surql"

export async function GET({ locals, url }) {
	const { user } = await authorise(locals)
	const query = url.searchParams.get("q")?.trim() as string

	const [assets] = await equery<Asset[][]>(inventoryQuery, {
		query,
		user: Record("user", user.id),
	})
	return json(assets)
}
