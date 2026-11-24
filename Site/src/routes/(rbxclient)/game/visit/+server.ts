import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"

export async function GET() {
	const script = await buildNamedLoadscript("visit", { PLACE_ID: 0 })

	return new Response(await SignScript(script))
}
