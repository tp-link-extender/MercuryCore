import { SignData } from "$lib/server/sign"

export async function GET() {
	const file = await Bun.file("../Corescripts/studio.lua").text()
	return new Response(await SignData(file))
}
