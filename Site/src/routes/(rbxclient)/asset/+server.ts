import { createHash } from "node:crypto"
import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

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
	if (!id || !intRegex.test(id)) error(400, "Invalid Request")
	console.log("Serving", id)

	try {
		// Try loading as an asset

		if (await Bun.file(`../data/assets/${id}`).exists()) {
			const [[asset]] = await equery<FoundAsset[][]>(
				surql`
					SELECT meta::id(id) AS id, name, visibility
					FROM ${Record("asset", +id)}`
			)

			if (!asset || asset.visibility === "Moderated")
				throw new Error("Asset not found")

			// The asset is visible or pending
			// (allow pending assets to be shown through the api)
			console.log(`serving asset #${id}`)
			const file = await Bun.file(`../data/assets/${id}`).arrayBuffer()
			return response(new Uint8Array(file))
		}

		// Try loading as a corescript

		const file = (
			await Bun.file(`../Corescripts/${id}.lua`).text()
		).replaceAll("roblox.com/asset", `${config.Domain}/asset`)

		console.log("serving corescript", id)
		return response(await SignData(file, +id))
	} catch {
		redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${id}`)
	}
}
