import { equery } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"
import gamesQuery from "./games.surql"

export type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

export async function load({ url }) {
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) redirect(303, "/games?p=1")

	const [places, pages] = await equery<[Place[], number]>(gamesQuery, {
		page: 1,
	})
	if (page > pages) redirect(303, `/games?p=${pages}`)

	return { places, pages }
}
