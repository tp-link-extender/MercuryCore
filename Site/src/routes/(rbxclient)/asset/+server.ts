import { createHash } from "node:crypto"
import { error } from "@sveltejs/kit"
import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
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

async function loadPrivilegedAsset(id: number) {
	const file = Bun.file(`../data/server/assets/${id}`)
	if (!(await file.exists())) return
	
	console.log("Serving privileged", id)
	const script = (await file.text()).replaceAll(
		"roblox.com/asset",
		`${config.Domain}/asset`
	)

	return response(script)
	}

export async function GET({ url }) {
	const assetId = url.searchParams.get("id")
	if (!assetId || !intRegex.test(assetId)) error(400, "Invalid Request")

	// all asset ids are now numbered
	const id = +assetId
	console.log("Requested asset", id)

	// just check it idc
	const result = await loadPrivilegedAsset(id)
	if (result) return result

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
