import { query, squery, surql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"

type Place = {
	id: number
	name: string
	playerCount: number
	serverPing: number
	likeCount: number
	dislikeCount: number
}

type Asset = {
	id: number
	name: string
	price: number
}

type Group = {
	name: string
	memberCount: number
}

export const load = async ({ url }) => {
	const searchQ = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""

	if (!searchQ) error(400, "Missing search query")
	if (category && !["users", "places", "assets", "groups"].includes(category))
		error(400, "Invalid category")

	if (category === "users") {
		const userExists = await squery<{ number: number }>(
			surql`
				SELECT number FROM user
				WHERE username = $searchQ`,
			{ searchQ }
		)

		if (userExists) redirect(302, `/user/${userExists.number}`)
	}

	// TODO: make this full-text search because that would be much nicer

	return {
		query: searchQ,
		category,
		users:
			category === "users" &&
			(await query<BasicUser>(
				surql`
					SELECT number, status, username
					FROM user
					WHERE string::lowercase($searchQ) INSIDE string::lowercase(username)`,
				{ searchQ }
			)),
		places:
			category === "places" &&
			(await query<Place>(
				surql`
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
					FROM place
					WHERE !privateServer
						AND !deleted
						AND string::lowercase($searchQ) INSIDE string::lowercase(name)`,
				{ searchQ }
			)),
		assets:
			category === "assets" &&
			(await query<Asset>(
				surql`
					SELECT meta::id(id) AS id, name, price
					FROM asset
					WHERE string::lowercase($searchQ) INSIDE string::lowercase(name)
						AND type INSIDE [17, 18, 2, 11, 12, 19]`,
				{ searchQ }
			)),
		groups:
			category === "groups" &&
			(await query<Group>(
				surql`
					SELECT
						name,
						count(<-member) AS memberCount
					FROM group
					WHERE string::lowercase($searchQ) INSIDE string::lowercase(name)`,
				{ searchQ }
			)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ url, request }) => {
	const data = await formData(request)
	const { query } = data
	const category = url.searchParams.get("c") || ""

	console.log(`searching for ${query} in ${category}`)

	redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
}
