import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

type Place = {
	id: string
	name: string
	playerCount: number
	serverPing: number
}

export const load = () => ({
	places: query<Place>(surql`
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
		WHERE !privateServer AND !deleted`),
})

export const actions = {
	default: async ({ request }) => ({
		places: await query<Place>(
			surql`
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
				WHERE !privateServer
					AND !deleted
					AND string::lowercase($query) ∈ string::lowercase(name)`,
			{ query: (await request.formData()).get("query") as string },
		),
	}),
}
