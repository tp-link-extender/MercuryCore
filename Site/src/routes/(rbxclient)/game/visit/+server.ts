import { SignData } from "$lib/server/sign"

export async function GET() {
	const file = await Bun.file("corescripts/processed/visit.lua").text()
	return new Response(await SignData(file.replaceAll("_PLACE_ID", "0")))
}
