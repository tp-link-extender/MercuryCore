import { authorise } from "$lib/server/lucia"
import { Record, equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import { type Asset, _select } from "../+page.server"

export async function GET({ locals, url }) {
	const { user } = await authorise(locals)

	const query = url.searchParams.get("q")?.trim() as string
	const [assets] = await equery<Asset[][]>(
		`${_select} AND string::lowercase($query) IN string::lowercase(name)`,
		{ query, user: Record("user", user.id) }
	)
	return json(assets)
}
