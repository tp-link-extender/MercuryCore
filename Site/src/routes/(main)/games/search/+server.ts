import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Place } from "../+page.server"
import gamesQuery from "../games.surql"

export async function GET({ url }) {
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : +pageQ

	const [places] = await equery<Place[][]>(gamesQuery, { query, page })
	return json(places)
}
