import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Place } from "../+page.server"
import gamesQuery from "../games.surql"

export async function GET({ url }) {
	const query = url.searchParams.get("q")?.trim() as string
	const [places] = await equery<Place[][]>(gamesQuery, { query })
	return json(places)
}
