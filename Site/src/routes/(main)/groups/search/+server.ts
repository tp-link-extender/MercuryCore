import { equery, surql } from "$lib/server/surreal"
import { json } from "@sveltejs/kit"
import type { Group } from "../+page.server"

export async function GET({ url }) {
	const q = url.searchParams.get("q")?.trim() as string
	const [groups] = await equery<Group[][]>(
		surql`
			SELECT name, count(<-member) AS memberCount FROM group
			WHERE string::lowercase(${q}) IN string::lowercase(name)`
	)
	return json(groups)
}
