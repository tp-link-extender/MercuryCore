import exclude from "$lib/server/exclude"
import { equery } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import groupsQuery from "./groups.surql"

export type Group = {
	name: string
	memberCount: number
}

export async function load({ url }) {
	exclude("Groups")
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) redirect(303, "/groups?p=1")

	const [groups, pages] = await equery<[Group[], number]>(groupsQuery, {
		page: 1,
	})
	if (page > pages) redirect(303, `/groups?p=${pages}`)

	return { groups, pages }
}
