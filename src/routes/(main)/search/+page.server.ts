import { query, squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"

export const load = async ({ url }) => {
	const searchQ = url.searchParams.get("q") || "",
		category = url.searchParams.get("c")?.toLowerCase() || ""

	if (!searchQ) error(400, "Missing search query")
	if (category && !["users", "places", "assets", "groups"].includes(category))
		error(400, "Invalid category")

	if (category == "users") {
		const userExists = await squery<{ number: number }>(
			surql`
				SELECT * FROM user
				WHERE username = $searchQ`,
			{ searchQ },
		)

		if (userExists) redirect(302, `/user/${userExists.number}`)
	}

	return {
		query: searchQ,
		category,
		users:
			category == "users" &&
			(await query<{
				number: number
				status: "Playing" | "Online" | "Offline"
				username: string
			}>(
				surql`
					SELECT
						number,
						status,
						username
					FROM user
					WHERE string::lowercase($searchQ) ∈ string::lowercase(username)`,
				{ searchQ },
			)),
		places:
			category == "places" &&
			(await query<{
				id: number
				name: string
				playerCount: number
				serverPing: number
				likeCount: number
				dislikeCount: number
			}>(
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
						AND string::lowercase($searchQ) ∈ string::lowercase(name)`,
				{ searchQ },
			)),
		assets:
			category == "assets" &&
			(await query<{
				id: number
				name: string
				price: number
			}>(
				surql`
					SELECT
						meta::id(id) AS id,
						name,
						price
					FROM asset
					WHERE string::lowercase($searchQ) ∈ string::lowercase(name)
						AND type ∈ [17, 18, 2, 11, 12, 19]`,
				{ searchQ },
			)),
		groups:
			category == "groups" &&
			(await query<{
				name: string
				memberCount: number
			}>(
				surql`
					SELECT
						name,
						count(<-member) AS memberCount
					FROM group
					WHERE string::lowercase($searchQ) ∈ string::lowercase(name)`,
				{ searchQ },
			)),
	}
}

export const actions = {
	default: async ({ url, request }) => {
		const data = await formData(request),
			{ query } = data,
			category = url.searchParams.get("c") || ""

		console.log(`searching for ${query} in ${category}`)

		redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
	},
}
