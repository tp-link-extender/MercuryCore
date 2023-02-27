import type { RequestHandler } from "./$types"
import { SignData } from "$lib/server/sign"
import { error, redirect } from "@sveltejs/kit"
import md5 from "crypto-js/md5"
import fs from "fs"

export const GET: RequestHandler = async ({ url, setHeaders }) => {
	const ID = url.searchParams.get("id")
	if (!ID || !/^\d+$/.test(ID)) throw error(400, "Invalid Request")

	if (fs.existsSync(`./corescripts/${ID}.lua`)) {
		let file = fs.readFileSync(`./corescripts/${ID}.lua`)

		setHeaders({
			"Content-Type": "binary/octet-stream",
			"Content-Disposition": `attachment; filename="${md5(file).toString()}"`,
		})

		let file2 = file.toString().replaceAll("roblox.com/asset", "banland.xyz/asset")

		// Health corescript
		if (ID != "38037265") file2 = SignData(file2, parseInt(ID))

		return new Response(file2)
	}

	throw redirect(302, `https://assetdelivery.roblox.com/v1/asset?id=${ID}`)
}
