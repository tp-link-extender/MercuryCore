import { error } from "@sveltejs/kit"
import { membershipType } from "$lib/permissionLevels"
import config from "$lib/server/config"
import idToPort, { proxyOffset } from "$lib/server/idToPort"
import { buildLoadscript, luaRaw } from "$lib/server/loadscript"
import { toRawId } from "$lib/server/recordId"
import { SignScript } from "$lib/server/sign"
import { db, findWhere, Record } from "$lib/server/surreal"
import type { RequestEvent } from "./$types"
import joinQuery from "./join.surql"

interface ServerAddress {
	serverHostname: string
	serverPort: number
}

interface Session {
	place: {
		id: number
		dedicated: boolean
	} & ServerAddress
	user: {
		permissionLevel: number
		username: string
	}
}

const serverDedicated = (dedicated: boolean) =>
	config.Gameservers.Hosting === "Both"
		? dedicated
		: config.Gameservers.Hosting === "Dedicated"

function serverInfo(place: Session["place"]): ServerAddress {
	if (!serverDedicated(place.dedicated)) return place

	const url = new URL(config.Orbiter.PublicURL)
	return {
		serverHostname: url.hostname, // no scheme, the address doesn't usually have a path anyway
		serverPort: idToPort(place.id) + proxyOffset, // select the proxy port rather than the port of the server itself
	}
}

const scriptHeaders = {
	"Cache-Control": "no-store",
	"Content-Type": "text/plain; charset=utf-8",
	"X-Content-Type-Options": "nosniff",
}

export async function GET({ url }: RequestEvent) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer")

	if (!clientTicket) {
		const scriptFile = Bun.file("../data/server/loadscripts/join.lua")
		const script = buildLoadscript(await scriptFile.text(), {
			CHAR_APPEARANCE: "",
			MEMBERSHIP_TYPE: luaRaw(membershipType(0)),
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

	const foundPrivatePlace = await findWhere(
		"place",
		"privateTicket = $privateServer",
		{ privateServer }
	)
	if (privateServer && !foundPrivatePlace)
		error(400, "Invalid Private Server")

	const playing = Record("playing", clientTicket)
	// also invalidates the session
	const [gameSession] = await db.query<Session[]>(joinQuery, { playing })
	if (!gameSession) error(400, "Invalid Game Session")

	const { place, user } = gameSession
	const { serverHostname, serverPort } = serverInfo(place)

	const charApp = `http://${config.DomainInsecure}/asset/characterfetch/${user.username}`
	const pingUrl = `http://${config.DomainInsecure}/game/clientpresence?ticket=${clientTicket}`
	const scriptFile = Bun.file("../data/server/loadscripts/join.lua")
	const script = buildLoadscript(await scriptFile.text(), {
		CHAR_APPEARANCE: charApp,
		MEMBERSHIP_TYPE: luaRaw(membershipType(user.permissionLevel)),
		PING_URL: pingUrl,
		PLACE_ID: luaRaw(toRawId(place.id)),
		SERVER_ADDRESS: serverHostname,
		SERVER_PORT: serverPort,
		USER_ID: Math.floor(Math.random() * 1e9), // todo: tho not rly used 4 much atm
		USERNAME: user.username,
	})

	return new Response(await SignScript(script), { headers: scriptHeaders })
}
