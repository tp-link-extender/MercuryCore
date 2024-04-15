import { query, surql } from "$lib/server/surreal"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

const select = (await import("./games.surql")).default

export const load = async () => ({
	places: await query<Place>(select),
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => ({
	places: await query<Place>(select, {
		query: (await request.formData()).get("q") as string,
	}),
})
