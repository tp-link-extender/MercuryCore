import type { Comment } from "#lib/comment.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import buyQuery from "./catalog/buy.surql"
import checkQuery from "./catalog/check.surql"
import findQuery from "./catalog/find.surql"
import iconQuery from "./catalog/icon.surql"
import listQuery from "./catalog/list.surql"
import nameQuery from "./catalog/name.surql"
import packageItemsQuery from "./catalog/packageItems.surql"
import pageQuery from "./catalog/page.surql"
import reuploadQuery from "./catalog/reupload.surql"
import settingsQuery from "./catalog/settings.surql"
import updateQuery from "./catalog/update.surql"

/** An asset as the catalog lists it. */
export interface CatalogAsset {
	id: number
	name: string
	price: number
}

export interface AssetPage {
	comments: Comment[]
	description: string | null
	forSale: boolean
	id: string
	name: string
	price: number
	type: number
	visibility: string
}

export interface AssetSettings {
	description: string | null
	forSale: boolean
	id: string
	imageAssetId: number | null
	name: string
	price: number
	type: number
	visibility: string
}

/**
 * Lists a page of the catalog, for one asset type or all of them, leaving out package contents.
 * @param packageItems The ids of assets inside packages, which are sold as bundles and not listed separately. Left out by the Assets tab, where the list is already filtered by type.
 * @returns The assets on the page, and how many pages there are.
 */
export async function catalogPage(args: {
	packageItems?: number[]
	page: number
	type?: number
}): Promise<{ assets: CatalogAsset[]; pages: number }> {
	const [assets, pages] = await dbQuery<[CatalogAsset[], number]>(
		listQuery,
		args
	)
	return { assets, pages }
}

/**
 * Searches the catalog from the search endpoint.
 * The query binds only the page, as the list query doesn't read the search text.
 */
export async function catalogSearch(
	page: number,
	query: string | undefined
): Promise<CatalogAsset[]> {
	const [assets] = await dbQuery<CatalogAsset[][]>(listQuery, { page, query })
	return assets
}

/** Finds the name of an asset. */
export async function assetNameOf(
	id: number
): Promise<{ name: string } | undefined> {
	const [[asset]] = await dbQuery<{ name: string }[][]>(nameQuery, {
		asset: Record("asset", id),
	})
	return asset
}

/**
 * Finds an asset as its page shows it, with its comments.
 * @returns The asset, or undefined if there is no such asset.
 */
export async function assetPageOf(
	id: number,
	viewer: RecordId<"user">
): Promise<AssetPage | undefined> {
	const [[asset]] = await dbQuery<AssetPage[][]>(pageQuery, {
		asset: Record("asset", id),
		user: viewer,
	})
	return asset
}

/** Finds what buying an asset needs to check, such as its price and whether it's for sale. */
export async function assetForSale(id: number): Promise<
	| {
			forSale: boolean
			name: string
			price: number
			type: number
			visibility: string
	  }
	| undefined
> {
	const [[asset]] = await dbQuery<
		{
			forSale: boolean
			name: string
			price: number
			type: number
			visibility: string
		}[][]
	>(buyQuery, { asset: Record("asset", id) })
	return asset
}

/** Finds the name, type and visibility of an asset, which rerendering needs. */
export async function assetFind(id: number): Promise<
	| {
			name: string
			type: number
			visibility: string
	  }
	| undefined
> {
	const [[asset]] = await dbQuery<
		{ name: string; type: number; visibility: string }[][]
	>(findQuery, { asset: Record("asset", id) })
	return asset
}

/** Finds what an asset's icon needs: its image asset, type, name and visibility. */
export async function assetIconOf(id: number): Promise<
	| {
			imageAssetId: number
			name: string
			type: number
			visibility: string
	  }
	| undefined
> {
	const [[asset]] = await dbQuery<
		{
			imageAssetId: number
			name: string
			type: number
			visibility: string
		}[][]
	>(iconQuery, { asset: Record("asset", id) })
	return asset
}

export interface AssetCheck {
	imageAssetId: number | null
	name: string
	type: number
}

/** Finds what the settings forms check before changing an asset. */
export async function assetCheckOf(
	id: number
): Promise<AssetCheck | undefined> {
	const [[check]] = await dbQuery<AssetCheck[][]>(checkQuery, {
		asset: Record("asset", id),
	})
	return check
}

/** Finds the fields the settings page edits. */
export async function assetSettingsOf(
	id: number
): Promise<AssetSettings | undefined> {
	const [[asset]] = await dbQuery<AssetSettings[][]>(settingsQuery, {
		asset: Record("asset", id),
	})
	return asset
}

/**
 * Updates an asset's details, sending a changed name or description back to review unless staff made the change.
 * @returns Whether the name or description changed.
 */
export async function updateAsset(args: {
	asset: RecordId<"asset">
	description: string
	forSale: boolean
	name: string
	price: number
	review: boolean
}): Promise<boolean> {
	const results = await dbQuery(updateQuery, args)
	return results.at(-1) === true
}

/** Stores a reuploaded file's visibility and records the upload in the audit log. */
export async function recordReupload(args: {
	asset: RecordId<"asset">
	note: string
	user: RecordId<"user">
	visibility: string
}): Promise<void> {
	await dbQuery(reuploadQuery, args)
}

/** The database details of an item inside a package. */
export interface PackageRow {
	id: number
	name: string
	type: number
	visibility: string
}

/**
 * Finds the database details of a package's contents, given their ids from the Economy service.
 * Ownership isn't read here, as the Economy service knows it.
 */
export async function packageRowsOf(
	ids: RecordId<"asset">[]
): Promise<PackageRow[]> {
	const [rows] = await dbQuery<PackageRow[][]>(packageItemsQuery, { ids })
	return rows
}
