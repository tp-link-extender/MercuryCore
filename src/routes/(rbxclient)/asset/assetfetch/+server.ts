import { SignData } from "$lib/server/sign"
import { error, redirect } from "@sveltejs/kit"
import md5 from "crypto-js/md5"
import fs from "fs"

export async function GET({ url, setHeaders }) {
	const ID = url.searchParams.get("id")
	if (!ID || !/^\d+$/.test(ID)) throw error(400, "Invalid Request")

	try {
		const file = fs.readFileSync(
			ID == "38037265"
				? "corescripts/38037265.xml"
				: `corescripts/processed/${ID}.lua`,
			"utf-8"
		)

		setHeaders({
			"Content-Type": "binary/octet-stream",
			"Content-Disposition": `attachment; filename="${md5(
				file
			).toString()}"`,
		})

		let file2 = file.replaceAll("roblox.com/asset", "banland.xyz/asset")

		// Health corescript
		if (ID != "38037265") file2 = SignData(file2, parseInt(ID))

		console.log("served corescript", ID)

		return new Response(file2)
	} catch {
		throw redirect(
			302,
			`https://assetdelivery.roblox.com/v1/asset?id=${ID}`
		)
	}
}
