import pageQuery from "$lib/server/pageQuery"
import { db } from "$lib/server/surreal"
import gamesQuery from "./games.surql"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

export async function load({ url }) {
	const { page, checkPages } = pageQuery(url)

	const [places, pages] = await db.query<[Place[], number]>(gamesQuery, {
		page,
	})
	checkPages(pages)

	return { places, pages }
}
