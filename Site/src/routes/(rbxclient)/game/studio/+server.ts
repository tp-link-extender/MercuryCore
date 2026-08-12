import { SignScript } from "$lib/server/sign"

export async function GET() {
	const script = await Bun.file(
		"../data/server/loadscripts/studio.lua"
	).text()

	return new Response(await SignScript(script))
}
