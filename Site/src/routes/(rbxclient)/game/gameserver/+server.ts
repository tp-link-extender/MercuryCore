import config from "#lib/server/config.ts"
import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"

const port = 53640

export async function GET() {
	const script = await buildNamedLoadscript("host", {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: "",
		SERVER_PORT: port,
		SERVER_PRESENCE_URL: "",
	})

	return new Response(await SignScript(script))
}
