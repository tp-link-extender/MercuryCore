import { createHash } from "node:crypto"
import { error } from "@sveltejs/kit"
import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import assetQuery from "./asset.surql"

const headers = (file: string | Uint8Array) => ({
	"Content-Type": "binary/octet-stream",
	"Content-Disposition": `attachment; filename="${createHash("md5")
		.update(file)
		.digest("hex")}"`,
})

const response = (file: string | Uint8Array) =>
	new Response(file, { headers: headers(file) })

type FoundAsset = {
	id: number
	name: string
	visibility: string
}

// you know how much I hate this thing, I don't even think I can rewrite it to make it better
const healthModelId = 38037265

export async function GET({ url }) {
	const assetId = url.searchParams.get("id")
	if (!assetId || !intRegex.test(assetId)) error(400, "Invalid Request")

	// all asset ids are now numbered
	const id = +assetId

	// corescript ids are 8 digits
	if (id < 100_000_000) {
		console.log("Serving corescript", id)

		const isHealthModel = id === healthModelId
		const file = Bun.file(
			`../Corescripts/${id}.${isHealthModel ? "xml" : "lua"}`
		)
		if (!(await file.exists())) error(404, "Corescript not found")

		const script = (await file.text()).replaceAll(
			"roblox.com/asset",
			`${config.Domain}/asset`
		)

		if (isHealthModel) return response(script)
		return response(await SignData(script))
	}

	// other asset ids are 9 digits
	if (id > 999_999_999) error(400, "Invalid Request")

	console.log("Serving", id)

	// Try loading as an asset
	if (!(await Bun.file(`../data/assets/${id}`).exists()))
		error(404, "Asset not found")

	const [[asset]] = await db.query<FoundAsset[][]>(assetQuery, {
		asset: Record("asset", id),
	})

	if (!asset || asset.visibility === "Moderated")
		error(404, "Asset not found")

	// The asset is visible or pending
	// (allow pending assets to be shown through the api)
	console.log(`serving asset #${id}`)
	const file = await Bun.file(`../data/assets/${id}`).arrayBuffer()
	return response(new Uint8Array(file))
}
