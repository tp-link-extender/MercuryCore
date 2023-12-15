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
			SELECT * FROM <-playing
			WHERE valid
				AND ping > time::now() - 35s
		) AS playerCount,
		count(<-likes) AS likeCount,
		count(<-dislikes) AS dislikeCount
	FROM place
	WHERE !privateServer AND !deleted`

export const load = async () => ({
	places: await query<Place>(select),
})

export const actions = {
	default: async ({ request }) => ({
		places: await query<Place>(
			surql`${select}
				AND string::lowercase($query) ∈ string::lowercase(name)`,
			{ query: (await request.formData()).get("q") as string },
		),
	}),
}
