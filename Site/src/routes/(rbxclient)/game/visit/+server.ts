import { SignData } from "$lib/server/sign"

export async function GET() {
	const scriptFile = Bun.file("../data/server/loadscripts/visit.lua")
	const script = (await scriptFile.text()).replaceAll("_PLACE_ID", "0")

	return new Response(await SignData(script))
}
