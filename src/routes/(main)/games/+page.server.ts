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
	const [places] = await equery<Place[][]>(gamesQuery)
	return { places }
}
