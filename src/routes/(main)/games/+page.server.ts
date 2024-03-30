import { query, surql } from "$lib/server/surreal"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

const select = surql`
	SELECT
		meta::id(id) AS id,
		name,
		serverPing,
		count(
			SELECT 1 FROM <-playing
			WHERE valid AND ping > time::now() - 35s
		) AS playerCount,
		count(<-likes) AS likeCount,
		count(<-dislikes) AS dislikeCount
	FROM place WHERE !privateServer AND !deleted
	ORDER BY playerCount DESC, serverPing DESC`

export const load = async () => ({
	places: await query<Place>(select),
})

export const actions: import("./$types").Actions = {}
actions.default = async ({ request }) => ({
	places: await query<Place>(
		surql`${select}
			AND string::lowercase($query) INSIDE string::lowercase(name)`,
		{ query: (await request.formData()).get("q") as string }
	),
})
