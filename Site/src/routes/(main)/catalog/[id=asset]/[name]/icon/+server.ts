import { error, redirect } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import { thumbnail, tShirtThumbnail } from "$lib/server/imageAsset"
import { db, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types"
import assetQuery from "./asset.surql"

type Asset = {
	name: string
	visibility: string
	type: number
	imageAssetId: number
}

const noRenderTypes = Object.freeze([1])

export async function GET({ locals, params }: RequestEvent) {
	const { user } = await authorise(locals)
	const id = Number(params.id)
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not Found")

	if (asset.visibility === "Moderated") redirect(302, "/moderated.svg")
	// If the asset is pending review
	if (asset.visibility !== "Visible" && user.permissionLevel < 4)
		redirect(302, "/error/mQuestion.svg")

	const dirs = ["thumbnails"]
	if (noRenderTypes.includes(asset.type)) dirs.push("assets") // load from assets dir as well

	for (const f of dirs.map(d => `../data/${d}/${id}`)) {
		const file = Bun.file(f)
		if (await file.exists()) return new Response(file)
	}

	// If the asset is visible, but the file doesn't exist (waiting for RCC?)
	switch (asset.type) {
		case 2: {
			// Recreate the T-Shirt thumbnail
			const file = Bun.file(`../data/assets/${asset.imageAssetId}`)
			if (await file.exists())
				// oxlint-disable-next-line promise/prefer-await-to-then -- render should not block the response
				void tShirtThumbnail(await file.arrayBuffer()).then(f => f(id))
			break
		}
		case 18: {
			// Recreate the icon thumbnail
			const file = Bun.file(`../data/assets/${asset.imageAssetId}`)
			if (await file.exists())
				// oxlint-disable-next-line promise/prefer-await-to-then -- render should not block the response
				void thumbnail(await file.arrayBuffer()).then(f => f(id))
			break
		}
	}

	redirect(302, "/dots.png")
}
