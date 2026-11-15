import config from "$lib/server/config"
import { buildLoadscript } from "$lib/server/loadscript"
import { SignScript } from "$lib/server/sign"

const port = 53640

export async function GET() {
	const scriptFile = Bun.file("../data/server/loadscripts/host.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		BASE_URL: config.DomainInsecure,
		MAP_LOCATION: "",
		SERVER_PORT: port,
		SERVER_PRESENCE_URL: "",
	})

	return new Response(await SignScript(script))
}
