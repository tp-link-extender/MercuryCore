import { equery, unpack } from "$lib/server/surreal"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

const select = await unpack(import("./games.surql"))

export async function load() {
	const [places] = await equery<Place[][]>(select)
	return { places }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => {
	const query = (await request.formData()).get("q") as string
	const [places] = await equery<Place[][]>(select, { query })
	return { places }
}
