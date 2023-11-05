import { SignData } from "$lib/server/sign"
import { squery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import md5 from "crypto-js/md5"
import fs from "fs"

export async function GET({ url, setHeaders }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) throw error(400, "Invalid Request")

	const apiKey = url.searchParams.get("apiKey")
	if (apiKey && apiKey != process.env.RCC_KEY) throw error(400, "Nerd")

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
				{ asset: `asset:${id}` },
			)

			if (!apiKey && (!asset || asset.visibility != "Visible"))
				throw new Error("Not authorised")


			console.log("apikey", apiKey)
			

			// The asset is visible, or the request is coming from RCCService

			const file = fs.readFileSync(`data/assets/${id}`, "utf-8")

			setHeaders({
				"Content-Type": "binary/octet-stream",
				"Content-Disposition": `attachment; filename="${md5(
					file,
				).toString()}"`,
			})

			console.log(`served asset #${id}`)

			return new Response(fs.readFileSync(`data/assets/${id}`))
		}

		// Try loading as a corescript

		const file = fs.readFileSync(
			id == "38037265"
				? "corescripts/38037265.xml"
				: id == "20573078"
				? "corescripts/20573078.xml"
				: `corescripts/processed/${id}.lua`,
			"utf-8",
		)

		setHeaders({
			"Content-Type": "binary/octet-stream",
			"Content-Disposition": `attachment; filename="${md5(
				file,
			).toString()}"`,
		})

		let file2 = file.replaceAll("roblox.com/asset", "banland.xyz/asset")

		// Health corescript and shaggy lol
		if (!["38037265", "20573078"].includes(id))
			file2 = SignData(file2, parseInt(id))

		console.log("served corescript", id)

		return new Response(file2)
	} catch (e) {
		throw redirect(
			302,
			`https://assetdelivery.roblox.com/v1/asset?id=${id}`,
		)
	}
}
