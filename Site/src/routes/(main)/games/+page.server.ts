import pageQuery from "$lib/server/pageQuery"
import { equery } from "$lib/server/surreal"
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

	const [places, pages] = await equery<[Place[], number]>(gamesQuery, {
		page,
	})
	checkPages(pages)

	return { places, pages }
}
