import { dbQuery } from "#lib/server/db/query.ts"
import assetsQuery from "./search/assets.surql"
import groupsQuery from "./search/groups.surql"
import placesQuery from "./search/places.surql"
import usersQuery from "./search/users.surql"

export interface SearchAsset {
	id: number
	name: string
	price: number
}

export interface SearchGroup {
	id: string
	memberCount: number
	name: string
}

export interface SearchPlace {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
}

export async function searchUsers(query: string): Promise<BasicUser[]> {
	const [users] = await dbQuery<BasicUser[][]>(usersQuery, { query })
	return users
}

export async function searchPlaces(query: string): Promise<SearchPlace[]> {
	const [places] = await dbQuery<SearchPlace[][]>(placesQuery, { query })
	return places
}

/**
 * Searches the catalog, leaving out package contents, which are sold as bundles.
 * @param packageItems The ids of assets inside packages.
 */
export async function searchAssets(
	query: string,
	packageItems: number[]
): Promise<SearchAsset[]> {
	const [assets] = await dbQuery<SearchAsset[][]>(assetsQuery, {
		packageItems,
		query,
	})
	return assets
}

export async function searchGroups(query: string): Promise<SearchGroup[]> {
	const [groups] = await dbQuery<SearchGroup[][]>(groupsQuery, { query })
	return groups
}
