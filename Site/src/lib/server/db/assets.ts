import { dbQuery } from "#lib/server/db/query.ts"
import { db, Record } from "#lib/server/surreal.ts"
import cachedThumbnailQuery from "./assets/thumbnailCache.surql"
import typeQuery from "./assets/type.surql"
import visibilityQuery from "./assets/visibility.surql"

export interface CachedThumbnail {
	height?: number
	url: string
	width?: number
}

/**
 * Finds the visibility of an asset, such as "Visible", "Pending" or "Moderated".
 * @returns The visibility, or undefined if there is no such asset.
 */
export async function assetVisibility(id: number): Promise<string | undefined> {
	const [[asset]] = await dbQuery<{ visibility: string }[][]>(
		visibilityQuery,
		{
			asset: Record("asset", id),
		}
	)
	return asset?.visibility
}

/**
 * Finds the body part type of an asset, which decides how it's rendered.
 * @returns The asset type, or undefined if there is no such asset.
 */
export async function assetType(id: number): Promise<number | undefined> {
	const [[asset]] = await dbQuery<{ type: number }[][]>(typeQuery, {
		asset: Record("asset", id),
	})
	return asset?.type
}

/** Finds the cached thumbnail of an asset, which is only valid for the size it was fetched at. */
export async function cachedThumbnail(
	id: number
): Promise<CachedThumbnail | undefined> {
	const [[cache]] = await dbQuery<CachedThumbnail[][]>(cachedThumbnailQuery, {
		cachedAsset: Record("thumbnailCache", id),
	})
	return cache
}

/** Stores the thumbnail of an asset at a size, creating the cache record on the first fetch. */
export async function cacheThumbnail(
	id: number,
	thumbnail: { height: number; url: string; width: number }
): Promise<void> {
	await db.upsert(Record("thumbnailCache", id)).merge(thumbnail)
}
