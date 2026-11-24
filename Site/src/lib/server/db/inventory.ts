import { dbQuery } from "#lib/server/db/query.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import groupsQuery from "./inventory/groups.surql"
import placesQuery from "./inventory/places.surql"
import unlimitedAssetsQuery from "./inventory/unlimitedAssets.surql"

export interface InventoryAsset {
	id: number
	name: string
	price: number
	type: number
}

export interface InventoryGroup {
	id: string
	memberCount: number
	name: string
}

export interface InventoryPlace {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
}

/** Finds the unlimited assets and package sources with these ids, which the inventory lists. */
export async function inventoryAssetsOf(
	ids: RecordId<"asset">[]
): Promise<InventoryAsset[]> {
	const [assets] = await dbQuery<[InventoryAsset[]]>(unlimitedAssetsQuery, {
		ids,
	})
	return assets
}

/** Finds the groups with these ids, with how many members each has. */
export async function inventoryGroupsOf(
	ids: RecordId<"group">[]
): Promise<InventoryGroup[]> {
	const [groups] = await dbQuery<[InventoryGroup[]]>(groupsQuery, { ids })
	return groups
}

/** Finds the places with these ids, with their players and likes. */
export async function inventoryPlacesOf(
	ids: RecordId<"place">[]
): Promise<InventoryPlace[]> {
	const [places] = await dbQuery<[InventoryPlace[]]>(placesQuery, { ids })
	return places
}
