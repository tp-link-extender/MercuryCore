import { idRegex, intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { db, Record } from "$lib/server/surreal"
import { createHash } from "node:crypto"
import { error, redirect } from "@sveltejs/kit"
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

export async function GET({ url }) {
	const id = url.searchParams.get("id")

	if (!id) error(400, "Invalid Request")
	// all numbered ids are corescripts (for now)

	if (intRegex.test(id)) {
		console.log("Serving corescript", id)

		const file = Bun.file(`../Corescripts/${id}.lua`)
		if (!(await file.exists())) error(404, "Corescript not found")

		const script = (await file.text()).replaceAll(
			"roblox.com/asset",
			`${config.Domain}/asset`
		)

		return response(await SignData(script))
	}

	if (!idRegex.test(id)) error(400, "Invalid Request")
	console.log("Serving", id)

	try {
		// Try loading as an asset

		if (!(await Bun.file(`../data/assets/${id}`).exists()))
			throw new Error("Asset not found")

		const [[asset]] = await db.query<FoundAsset[][]>(assetQuery, {
			asset: Record("asset", id),
		})

		if (!asset || asset.visibility === "Moderated")
			throw new Error("Asset not found")

		// The asset is visible or pending
		// (allow pending assets to be shown through the api)
		console.log(`serving asset #${id}`)
		const file = await Bun.file(`../data/assets/${id}`).arrayBuffer()
		return response(new Uint8Array(file))
	} catch {
		redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${id}`)
	}
}
