import { equery } from "$lib/server/surreal"
import gamesQuery from "./games.surql"

export type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

export async function load() {
	const [places, pages] = await equery<[Place[], number]>(gamesQuery, {
		page: 1,
	})

	return { places, pages }
}
