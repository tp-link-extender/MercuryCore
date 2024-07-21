import { createHash } from "node:crypto"
import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

const response = (file: Buffer | string) =>
	new Response(file, {
		headers: {
			"Content-Type": "binary/octet-stream",
			"Content-Disposition": `attachment; filename="${createHash("md5")
				.update(file)
				.digest("hex")}"`,
		},
	})

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

		if (await Bun.file(`data/assets/${id}`).exists()) {
			const [[asset]] = await equery<FoundAsset[][]>(
				surql`
					SELECT meta::id(id) AS id, name, visibility
					FROM ${Record("asset", +id)}`
			)

			if (!asset || asset.visibility === "Moderated")
				throw new Error("Asset not found")

			// The asset is visible or pending
			// (allow pending assets to be shown through the api)
			console.log(`served asset #${id}`)

			return response(
				Buffer.from(await Bun.file(`data/assets/${id}`).arrayBuffer())
			)
		}

		// Try loading as a corescript

		const isHealthCorescript = id === "38037265"
		const file = await Bun.file(
			isHealthCorescript
				? "corescripts/38037265.xml"
				: `corescripts/processed/${id}.lua` // shaggy removed
		).text()

		let file2 = file.replaceAll(
			"roblox.com/asset",
			`${config.Domain}/asset`
		)

		// please rewrite the health corescript
		if (!isHealthCorescript) file2 = await SignData(file2, +id)

		console.log("served corescript", id)

		return response(file2)
	} catch {
		redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${id}`)
	}
}
