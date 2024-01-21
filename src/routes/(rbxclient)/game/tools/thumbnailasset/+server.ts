// This should be moved to asset thumbnails for every asset on Mercury, but
// for now we'll use it for the stamper tool (and other games which require it)

import surreal, { squery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function GET({ url }) {
	const width = parseInt(url.searchParams.get("wd") as string)
	const height = parseInt(url.searchParams.get("ht") as string)
	const assetId = parseInt(url.searchParams.get("aid") as string)
	const stringAssetId = assetId.toString()

	if (!assetId || !width || !height) error(404, "Asset not found")

	const params = new URLSearchParams({
		assetIds: stringAssetId,
		returnPolicy: "Placeholder",
		size: `${width}x${height}`,
		format: "Png",
		isCircular: "false",
	})
	const cache = await squery<{ url: string }>(surql`SELECT * FROM $asset`, {
		asset: `assetCache:${stringAssetId}`,
	})

	if (cache) redirect(302, cache.url)

	const thumb = await fetch(
		`https://thumbnails.roblox.com/v1/assets?${params}`
	)

	if (thumb.status !== 200) error(400, "Invalid asset")

	const thumbnail = JSON.parse(await thumb.text())

	await surreal.merge(`assetCache:${stringAssetId}`, {
		url: thumbnail.data[0].imageUrl,
	})

	redirect(302, thumbnail.data[0].imageUrl)
}
