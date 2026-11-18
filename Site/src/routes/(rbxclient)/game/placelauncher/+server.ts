import { buildLoadscript } from "#lib/server/loadscript.ts"
import { SignScript } from "#lib/server/sign.ts"

export async function GET() {
	const scriptFile = Bun.file("../data/server/loadscripts/visit.lua")
	const script = buildLoadscript(await scriptFile.text(), { PLACE_ID: 0 })

	return new Response(await SignScript(script))
}
