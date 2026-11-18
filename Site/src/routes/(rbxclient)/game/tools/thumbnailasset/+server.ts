// This should be moved to asset thumbnails for every asset on Mercury, but for now we'll use it for the stamper tool (and other games which require it)

import { error, redirect } from "@sveltejs/kit"
import { db, Record } from "#lib/server/surreal.ts"
import type { RequestEvent } from "./$types"
import cachedAssetQuery from "./cache.surql"

const isThumbnailResponse = (
	value: unknown
): value is { data: { imageUrl: string }[] } => {
	if (typeof value !== "object" || value === null || !("data" in value))
		return false
	const { data } = value
	if (!Array.isArray(data)) return false
	const first: unknown = data[0]
	return (
		typeof first === "object" &&
		first !== null &&
		"imageUrl" in first &&
		typeof first.imageUrl === "string"
	)
}

export async function GET({ fetch: f, url }: RequestEvent) {
	const width = Number(url.searchParams.get("wd"))
	const height = Number(url.searchParams.get("ht"))
	const assetId = Number(url.searchParams.get("aid"))
	const stringAssetId = assetId.toString()

	if (!assetId || !width || !height) error(404, "Asset not found")

	const cachedAsset = Record("thumbnailCache", assetId)
	const [[cache]] = await db.query<
		{ height?: number; url: string; width?: number }[][]
	>(cachedAssetQuery, { cachedAsset })
	// The cached URL is for one size, so it can only answer a request for the same size
	if (cache && cache.width === width && cache.height === height)
		redirect(302, cache.url, { external: true })

	const params = new URLSearchParams({
		assetIds: stringAssetId,
		format: "Png",
		isCircular: "false",
		returnPolicy: "Placeholder",
		size: `${width}x${height}`,
	})
	const thumb = await f(`https://thumbnails.roblox.com/v1/assets?${params}`)

	if (thumb.status !== 200) error(400, "Invalid asset")

	const body: unknown = JSON.parse(await thumb.text())
	if (!isThumbnailResponse(body)) error(400, "Invalid asset")
	const [{ imageUrl }] = body.data
	// Stored with the size, so a later request for another size doesn't get this URL
	// UPSERT, since the cache record is new on the first fetch
	await db.upsert(cachedAsset).merge({ height, url: imageUrl, width })

	redirect(302, imageUrl, { external: true })
}
