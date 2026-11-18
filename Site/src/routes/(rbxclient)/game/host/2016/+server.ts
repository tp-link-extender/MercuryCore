import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { buildLoadscript, luaId } from "#lib/server/loadscript.ts"
import { SignScript } from "#lib/server/sign.ts"
import { db } from "#lib/server/surreal.ts"
import placeQuery from "../place.surql"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	if (config.Gameservers.Hosting === "Dedicated")
		error(400, "Selfhosted servers are not supported")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	const [[place]] = await db.query<{ serverPort: number; id: number }[][]>(
		placeQuery,
		{ ticket }
	)
	if (!place) error(400, "Invalid Server ticket")

	const port = place.serverPort
	const serverId = place.id

	console.log(`Hosting 2016 server ${serverId} on port ${port}`)

	// Autopilot map substitution is disabled for now. If it is re-enabled, pass parseMapLocation(url.searchParams.get("autopilot")) as MAP_LOCATION.
	const scriptFile = Bun.file("../data/server/loadscripts/host2016.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		BASE_URL: config.Domain,
		MAP_LOCATION: "rbxasset://mbdtf.rbxl", // TODO: remove hardcoded map
		PLACE_ID: luaId(serverId),
		SERVER_PORT: port,
	})

	return new Response(await SignScript(script), {
		headers: {
			"Cache-Control": "no-store",
			"Content-Type": "text/plain; charset=utf-8",
			"X-Content-Type-Options": "nosniff",
		},
	})
}
