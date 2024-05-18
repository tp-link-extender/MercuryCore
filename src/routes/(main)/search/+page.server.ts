import { equery, surrealql } from "$lib/server/surreal"
import formData from "$lib/server/formData"
import { error, redirect } from "@sveltejs/kit"
import searchUsersQuery from "./searchUsers.surql"
import searchPlacesQuery from "./searchPlaces.surql"
import searchAssetsQuery from "./searchAssets.surql"
import searchGroupsQuery from "./searchGroups.surql"

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
		const [[userExists]] = await equery<{ number: number }[][]>(
			surrealql`
				SELECT number FROM user
				WHERE username = ${searchQ}`
		)

		if (userExists) redirect(302, `/user/${userExists.number}`)
	}

	// TODO: make this full-text search because that would be much nicer
	const searches: {
		users?: BasicUser[]
		places?: Place[]
		assets?: Asset[]
		groups?: Group[]
	} = {}

	if (category === "users") {
		const [users] = await equery<BasicUser[][]>(searchUsersQuery, param)
		searches.users = users
	}
	if (category === "places") {
		const [places] = await equery<Place[][]>(searchPlacesQuery, param)
		searches.places = places
	}
	if (category === "assets") {
		const [assets] = await equery<Asset[][]>(searchAssetsQuery, param)
		searches.assets = assets
	}
	if (category === "groups") {
		const [groups] = await equery<Group[][]>(searchGroupsQuery, param)
		searches.groups = groups
	}

	return { query: searchQ, category, ...searches }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ url, request }) => {
	const data = await formData(request)
	const { query } = data
	const category = url.searchParams.get("c") || ""

	console.log(`searching for ${query} in ${category}`)

	redirect(302, `/search?q=${query}${category ? `&c=${category}` : ""}`)
}
