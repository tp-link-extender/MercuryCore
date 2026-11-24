import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"

export async function GET() {
	const script = await buildNamedLoadscript("studio", {})

	return new Response(await SignScript(script))
}
