import exclude from "$lib/server/exclude"
import { equery } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Group } from "../+page.server"
import groupsQuery from "../groups.surql"

export async function GET({ url }) {
	exclude("Groups")
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.max(1, Math.round(+pageQ))

	const [groups] = await equery<Group[][]>(groupsQuery, { query, page })
	return json(groups)
}
