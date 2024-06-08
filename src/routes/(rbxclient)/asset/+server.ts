import { createHash } from "node:crypto"
import { intRegex } from "$lib/paramTests"
import { SignData } from "$lib/server/sign"
import { RecordId, equery, surql } from "$lib/server/surreal"
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

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !intRegex.test(id)) error(400, "Invalid Request")
	console.log(`Serving ${id}`)

	try {
		// Try loading as an asset

		if (await Bun.file(`data/assets/${id}`).exists()) {
			const [[asset]] = await equery<
				{
					id: number
					name: string
					visibility: string
				}[][]
			>(
				surql`
					SELECT
						meta::id(id) AS id,
						name,
						visibility
					FROM ${new RecordId("asset", id)}`
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

		const file = await Bun.file(
			id === "38037265"
				? "corescripts/38037265.xml"
				: `corescripts/processed/${id}.lua` // shaggy removed
		).text()

		let file2 = file.replaceAll(
			"roblox.com/asset",
			`${process.env.DOMAIN}/asset`
		)

		// Health corescript lol
		if (id !== "38037265") file2 = await SignData(file2, +id)

		console.log("served corescript", id)

		return response(file2)
	} catch {
		redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${id}`)
	}
}
