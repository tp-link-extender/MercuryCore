import { createHash } from "node:crypto"
import { error } from "@sveltejs/kit"
import { OPEN_CLOUD_KEY } from "$env/static/private"
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

const substituteURLs = (script: string) =>
	script.replaceAll("roblox.com/asset", `${config.Domain}/asset`)

async function loadPrivilegedAsset(id: number) {
	const file = Bun.file(`../data/server/assets/${id}`)
	if (!(await file.exists())) return

	// Privileged assets don't need their URLs substituted

	console.log("Serving privileged", id)
	return response(new Uint8Array(await file.arrayBuffer()))
}

async function loadUserAsset(id: number) {
	const file = Bun.file(`../data/assets/${id}`)
	if (!(await file.exists())) return

	const [[asset]] = await db.query<FoundAsset[][]>(assetQuery, {
		asset: Record("asset", id),
	})
	if (!asset || asset.visibility === "Moderated") return

	// The asset is visible or pending
	// (allow pending assets to be shown through the api)
	const script = substituteURLs(await file.text())

	console.log("Serving user", id)
	return response(script)
}

async function loadOpenCloudAsset(id: number) {
	const cachepath = `../data/assetcache/${id}`
	const file = Bun.file(cachepath)
	if (await file.exists())
		return response(new Uint8Array(await file.arrayBuffer()))

	try {
		const req = await fetch(
			`https://apis.roblox.com/asset-delivery-api/v1/assetId/${id}`,
			{ headers: { "X-API-Key": OPEN_CLOUD_KEY } }
		)
		if (!req.ok) return

		const json = (await req.json()) as { location: string }
		const location = json.location
		if (!location) return

		const res = await fetch(location)
		if (!res.ok) return

		// cache the asset
		const script = substituteURLs(await res.text())
		await Bun.write(cachepath, script)

		console.log("Serving Open Cloud", id)
		return response(script)
	} catch (e) {
		console.error(e)
		error(500, "Failed to fetch Open Cloud asset")
	}
}

export async function GET({ url }) {
	const assetId = url.searchParams.get("id")
	if (!assetId || !intRegex.test(assetId)) error(400, "Invalid Request")

	// all asset ids are now numbered
	const id = +assetId
	console.log("Requested asset", id)

	const result1 = await loadPrivilegedAsset(id)
	if (result1) return result1

	// Try loading as a user asset
	const result2 = await loadUserAsset(id)
	if (result2) return result2

	const result3 = await loadOpenCloudAsset(id)
	if (result3) return result3

	error(404, "Not Found")
}
