import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import gamesQuery from "./games.surql"

interface Place {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
	serverPing: number
}

export async function load({ url }: PageServerLoadEvent) {
	const { page, checkPages } = pageQuery(url)

	const [places, pages] = await db.query<[Place[], number]>(gamesQuery, {
		page,
	})
	checkPages(pages)

	return { pages, places }
}
