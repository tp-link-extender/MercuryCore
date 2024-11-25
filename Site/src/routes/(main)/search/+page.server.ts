import { db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
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

export async function load({ url }) {
	const query = url.searchParams.get("q") || ""
	const category = url.searchParams.get("c")?.toLowerCase() || ""
	if (!query) error(400, "Missing search query")

	const param = { query }

	// TODO: make this full-text search because that would be much nicer
	switch (category) {
		case "users": {
			// convenient, but easy to abuse
			// const foundUser = await findWhere(
			// 	"user",
			// 	"username = $query",
			// 	param
			// )
			// if (foundUser) redirect(302, `/user/${query}`)

			const [users] = await db.query<BasicUser[][]>(
				searchUsersQuery,
				param
			)
			return { query, category, users }
		}
		case "places": {
			const [places] = await db.query<Place[][]>(searchPlacesQuery, param)
			return { query, category, places }
		}
		case "assets": {
			const [assets] = await db.query<Asset[][]>(searchAssetsQuery, param)
			return { query, category, assets }
		}
		case "groups": {
			const [groups] = await db.query<Group[][]>(searchGroupsQuery, param)
			return { query, category, groups }
		}
		default:
			error(400, "Invalid category")
	}
}
