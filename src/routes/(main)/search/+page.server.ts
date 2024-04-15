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

	const param = { searchQ }

	if (category === "users") {
		const userExists = await squery<{ number: number }>(
			surql`
				SELECT number FROM user
				WHERE username = $searchQ`,
			param
		)

		if (userExists) redirect(302, `/user/${userExists.number}`)
	}

	// TODO: make this full-text search because that would be much nicer

	return {
		query: searchQ,
		category,
		...(category === "users" && {
			users: await query<BasicUser>(import("./searchUsers.surql"), param),
		}),
		...(category === "places" && {
			places: await query<Place>(import("./searchPlaces.surql"), param),
		}),
		...(category === "assets" && {
			assets: await query<Asset>(import("./searchAssets.surql"), param),
		}),
		...(category === "groups" && {
			groups: await query<Group>(import("./searchGroups.surql"), param),
		}),
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
