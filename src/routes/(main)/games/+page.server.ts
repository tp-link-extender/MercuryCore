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

export async function load() {
	const [places] = await equery<Place[][]>(gamesQuery)
	return { places }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => {
	const query = (await request.formData()).get("q") as string
	const [places] = await equery<Place[][]>(gamesQuery, { query })
	return { places }
}
