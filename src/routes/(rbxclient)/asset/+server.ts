import { SignData } from "$lib/server/sign"
import { squery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import { createHash } from "node:crypto"
import fs from "node:fs"

const response = (file: string) =>
	new Response(file, {
		headers: {
			"Content-Type": "binary/octet-stream",
			"Content-Disposition": `attachment; filename="${createHash("md5")
				.update(file)
				.digest("hex")}"`,
		},
	})

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	console.log(`Serving ${id}`)
	if (!id || !/^\d+$/.test(id)) error(400, "Invalid Request")

	try {
		// Try loading as an asset

		if (fs.existsSync(`data/assets/${id}`)) {
			const asset = await squery<{
				id: number
				name: string
				visibility: string
			}>(
				surql`
					SELECT
						meta::id(id) AS id,
						name,
						visibility
					FROM $asset`,
				{ asset: `asset:${id}` }
			)

			if (!asset || asset.visibility === "Moderated") throw new Error()

			// The asset is visible or pending
			// (allow pending assets to be shown through the api)
			console.log(`served asset #${id}`)

			return response(fs.readFileSync(`data/assets/${id}`, "utf-8"))
		}

		// Try loading as a corescript

		const file = fs.readFileSync(
			id === "38037265"
				? "corescripts/38037265.xml"
				: `corescripts/processed/${id}.lua`, // shaggy removed
			"utf-8"
		)

		let file2 = file.replaceAll("roblox.com/asset", "banland.xyz/asset")

		// Health corescript and shaggy lol
		if (!["38037265", "20573078"].includes(id)) file2 = SignData(file2, +id)

		console.log("served corescript", id)

		return response(file2)
	} catch {
		redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${id}`)
	}
}
