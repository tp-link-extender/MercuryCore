import { error } from "@sveltejs/kit"
import { membershipType } from "#lib/permissionLevels.ts"
import config from "#lib/server/config.ts"
import { luaId, luaName } from "#lib/server/loadscript.ts"
import { buildNamedLoadscript } from "#lib/server/loadscriptFile.ts"
import { SignScript } from "#lib/server/sign.ts"
import type { RequestEvent } from "./$types"
import { claimSession } from "./session.ts"

const scriptHeaders = {
	"Cache-Control": "no-store",
	"Content-Type": "text/plain; charset=utf-8",
	"X-Content-Type-Options": "nosniff",
}

export async function GET({ url }: RequestEvent) {
	const clientTicket = url.searchParams.get("ticket")

	if (!clientTicket) {
		const script = await buildNamedLoadscript("join", {
			CHAR_APPEARANCE: "",
			CREATOR_ID: 0,
			MEMBERSHIP_TYPE: luaName(membershipType(0)),
			PING_URL: "",
			PLACE_ID: 0,
			SERVER_ADDRESS: "localhost",
			SERVER_PORT: 53640,
			USER_ID: 0,
			USERNAME: "Player1",
		})

		return new Response(await SignScript(script), {
			headers: scriptHeaders,
		})
	}

	const session = await claimSession(clientTicket)
	if (!session) error(400, "Invalid Game Session")
	const { place, serverAddress, serverPort, user } = session

	const charApp = `http://${config.DomainInsecure}/asset/characterfetch/${user.username}`
	const pingUrl = `http://${config.DomainInsecure}/game/clientpresence?ticket=${clientTicket}`
	const script = await buildNamedLoadscript("join", {
		CHAR_APPEARANCE: charApp,
		CREATOR_ID: 0, // todo: the place's creator
		MEMBERSHIP_TYPE: luaName(membershipType(user.permissionLevel)),
		PING_URL: pingUrl,
		PLACE_ID: luaId(place.id),
		SERVER_ADDRESS: serverAddress,
		SERVER_PORT: serverPort,
		USER_ID: Math.floor(Math.random() * 1e9), // todo: tho not rly used 4 much atm
		USERNAME: user.username,
	})

	return new Response(await SignScript(script), { headers: scriptHeaders })
}
