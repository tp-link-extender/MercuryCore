import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"

export const load = async ({ url }) => {
	const query = url.searchParams.get("q") || "",
		category = url.searchParams.get("c")?.toLowerCase() || ""

	if (!query) throw error(400, "No query provided")
	if (category && !["users", "places", "assets", "groups"].includes(category))
		throw error(400, "Invalid category")

	if (category == "users") {
		const userExists = (
			(await squery(
				surql`
					SELECT * FROM user
					WHERE username = $query`,
				{ query },
			)) as { number: number }[]
		)[0]

		if (userExists) throw redirect(302, `/user/${userExists.number}`)
	}

	return {
		query,
		category,
		users:
			category == "users" &&
			(squery(
				surql`
					SELECT
						number,
						username
					FROM user
					WHERE string::lowercase($query) ∈ string::lowercase(username)`,
				{ query },
			) as Promise<
				{
					number: number
					username: string
				}[]
			>),
		places:
			category == "places" &&
			(squery(
				surql`
					SELECT
						string::split(type::string(id), ":")[1] AS id,
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
				{ query },
			) as Promise<
				{
					id: number
					name: string
					playerCount: number
					serverPing: number
					likeCount: number
					dislikeCount: number
				}[]
			>),
		assets:
			category == "assets" &&
			(squery(
				surql`
					SELECT
						string::split(type::string(id), ":")[1] AS id,
						name,
						price
					FROM asset
					WHERE string::lowercase($query) ∈ string::lowercase(name)`,
				{ query },
			) as Promise<
				{
					id: number
					name: string
					price: number
				}[]
			>),
		groups:
			category == "groups" &&
			(squery(
				surql`
					SELECT
						name,
						count(<-member) AS memberCount
					FROM group
					WHERE string::lowercase($query) ∈ string::lowercase(name)`,
				{ query },
			) as Promise<
				{
					name: string
					memberCount: number
				}[]
			>),
	}
}

export const actions = {
	default: async ({ url, request }) => {
		const data = await formData(request),
			{ query } = data,
			category = url.searchParams.get("c") || ""

		console.log(`searching for ${query} in ${category}`)

		throw redirect(
			302,
			`/search?q=${query}${category ? `&c=${category}` : ""}`,
		)
	},
}
