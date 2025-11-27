import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { SignData } from "$lib/server/sign"
import { db } from "$lib/server/surreal"
import placeQuery from "./place.surql"

export async function GET({ url }) {
	const port = 53640

	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = (await scriptFile.text())
		.replaceAll("_BASE_URL", `"${config.Domain}"`)
		.replaceAll("_MAP_LOCATION", `""`)
		.replaceAll("_SERVER_PORT", port.toString())
		.replaceAll("_SERVER_PRESENCE_URL", `""`)

	return new Response(await SignData(script))
}
