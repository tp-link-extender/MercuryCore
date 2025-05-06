import { authorise } from "$lib/server/auth"
import { tShirtThumbnail } from "$lib/server/imageAsset"
import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import assetQuery from "./asset.surql"

type Asset = {
	name: string
	visibility: string
	type: number
	imageAssetId: number
}

export async function GET({ locals, params }) {
	const { user } = await authorise(locals)
	const id = +params.id
	const [[asset]] = await db.query<Asset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset) error(404, "Not found")

	if (asset.visibility === "Moderated") redirect(302, "/moderated.svg")
	// If the asset is pending review
	if (asset.visibility !== "Visible" && user.permissionLevel < 4)
		redirect(302, "/error/mQuestion.svg")

	const dirs = ["thumbnails"]
	if (asset.type === 1) dirs.push("assets") // load from assets dir as well

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
				tShirtThumbnail(await file.arrayBuffer()).then(f => f(id))
			break
		}
		default:
	}

	redirect(302, "/dots.png")
}
