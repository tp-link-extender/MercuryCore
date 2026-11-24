import { dbQuery } from "#lib/server/db/query.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import type { PageServerLoadEvent } from "./$types"
import gamesQuery from "./games.surql"

interface Place {
	clientVersion: number
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
	serverPing: number
}

export async function load({ url }: PageServerLoadEvent) {
	const { page, checkPages } = pageQuery(url)

	const [places, pages] = await dbQuery<[Place[], number]>(gamesQuery, {
		page,
	})
	checkPages(pages)

	return { pages, places }
}
