import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import equipQuery from "./character/equip.surql"
import equipDataQuery from "./character/equipData.surql"
import equipPackageQuery from "./character/equipPackage.surql"
import hatsEquippedQuery from "./character/hatsEquipped.surql"
import unequipQuery from "./character/unequip.surql"
import unequipPackageQuery from "./character/unequipPackage.surql"
import wardrobeQuery from "./character/wardrobe.surql"
import wornQuery from "./character/worn.surql"

/** An asset as the wardrobe lists it, and whether it's worn. */
export interface WardrobeAsset {
	id: number
	name: string
	price: number
	type: number
	wearing: boolean
}

/** What equipping an asset checks before it's worn. */
export interface EquipData {
	id: number
	type: number
	visibility: string
}

/**
 * Lists the assets of these types the user can see, including ones they're wearing.
 * @param assets The assets to choose from, such as the ones the user owns.
 */
export async function wardrobeOf(args: {
	allowedTypes: readonly number[]
	assets: RecordId<"asset">[]
	user: RecordId<"user">
}): Promise<WardrobeAsset[]> {
	const [assets] = await dbQuery<WardrobeAsset[][]>(wardrobeQuery, args)
	return assets
}

/** Finds whether the user is wearing each of these assets. */
export async function wornStatesOf(
	ids: number[],
	user: RecordId<"user">
): Promise<{ id: number; worn: boolean }[]> {
	const [worn] = await dbQuery<{ id: number; worn: boolean }[][]>(wornQuery, {
		ids,
		user,
	})
	return worn
}

/** Finds what equipping an asset checks, such as its type and visibility. */
export async function equipDataOf(id: number): Promise<EquipData | undefined> {
	const [[asset]] = await dbQuery<EquipData[][]>(equipDataQuery, {
		asset: Record("asset", id),
	})
	return asset
}

/**
 * Wears an asset. A one-per-slot item (shirts, pants and faces) replaces what's already worn in its slot.
 * @param type The asset's type, for a one-per-slot item, and undefined for anything else.
 */
export async function equipAsset(
	asset: RecordId<"asset">,
	user: RecordId<"user">,
	type: number | undefined
): Promise<void> {
	await dbQuery(equipQuery, { asset, type, user })
}

/** Counts the hats the user is wearing. */
export async function hatsWorn(user: RecordId<"user">): Promise<number> {
	const [hats] = await dbQuery<number[]>(hatsEquippedQuery, { user })
	return hats
}

/** Wears a package's items, replacing anything in the slots they occupy. */
export async function equipPackage(args: {
	children: RecordId<"asset">[]
	conflicting: number[]
	user: RecordId<"user">
}): Promise<void> {
	await dbQuery(equipPackageQuery, args)
}

export async function unequipAsset(
	asset: RecordId<"asset">,
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(unequipQuery, { asset, user })
}

export async function unequipPackage(args: {
	children: RecordId<"asset">[]
	user: RecordId<"user">
}): Promise<void> {
	await dbQuery(unequipPackageQuery, args)
}
