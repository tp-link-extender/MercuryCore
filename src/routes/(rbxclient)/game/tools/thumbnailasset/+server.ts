// this should be moved to asset thumbnails for every asset on mercury but for now we'll use it for the stamper tool (and other games which require it)

import { error, redirect } from "@sveltejs/kit"
import { client } from "$lib/server/redis"

export async function GET({ url }) {
	const width = parseInt(url.searchParams.get("wd") as string)
	const height = parseInt(url.searchParams.get("ht") as string)
	const assetId = parseInt(url.searchParams.get("aid") as string)

	if (!assetId || !width || !height) throw error(404, "Asset not found")

	const params = new URLSearchParams({
		assetIds: assetId.toString(),
		returnPolicy: "Placeholder",
		size: `${width}x${height}`,
		format: "Png",
		isCircular: "false",
	})
    
    const cache = await client.hGet("thumbnailAsset", assetId.toString())

    if(cache) throw redirect(302, cache)

	const thumb = await fetch(`https://thumbnails.roblox.com/v1/assets?${params}`)

	if (thumb.status == 200) {
		const thumbnail = JSON.parse(await thumb.text())

        await client.hSet("thumbnailAsset", assetId.toString(), thumbnail.data[0].imageUrl)

		throw redirect(302, thumbnail.data[0].imageUrl)
	}

	throw error(400, "Invalid asset")
}
