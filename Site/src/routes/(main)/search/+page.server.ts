import formData from "$lib/server/formData"
import { authorise } from "$lib/server/lucia"
import { equery, findWhere } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import searchAssetsQuery from "./searchAssets.surql"
import searchGroupsQuery from "./searchGroups.surql"
import searchPlacesQuery from "./searchPlaces.surql"
import searchUsersQuery from "./searchUsers.surql"

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
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) error(400, "Missing search query")

	const param = { query }

	// TODO: make this full-text search because that would be much nicer
	switch (category) {
		case "users": {
			const foundUser = await findWhere("user", "username = $username", {
				username: query,
			})
			if (foundUser) redirect(302, `/user/${query}`)

			const [users] = await equery<BasicUser[][]>(searchUsersQuery, param)
			return { query, category, users }
		}
		case "places": {
			const [places] = await equery<Place[][]>(searchPlacesQuery, param)
			return { query, category, places }
		}
		case "assets": {
			const [assets] = await equery<Asset[][]>(searchAssetsQuery, param)
			return { query, category, assets }
		}
		case "groups": {
			const [groups] = await equery<Group[][]>(searchGroupsQuery, param)
			return { query, category, groups }
		}
		default:
			error(400, "Invalid category")
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ url, request, locals }) => {
	await authorise(locals)

	const { query } = await formData(request)
	const category = url.searchParams.get("c")

	console.log(`searching for ${query} in ${category}`)
	redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
}
