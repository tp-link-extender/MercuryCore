import { error } from "@sveltejs/kit"
import { membershipType } from "$lib/permissionLevels"
import config from "$lib/server/config"
import idToPort, { proxyOffset } from "$lib/server/idToPort"
import { buildLoadscript, luaRaw } from "$lib/server/loadscript"
import { toRawId } from "$lib/server/recordId"
import { SignScript } from "$lib/server/sign"
import { db, findWhere, Record } from "$lib/server/surreal"
import joinQuery from "./join.surql"

type ServerAddress = {
	serverHostname: string
	serverPort: number
}

type Session = {
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

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) {
		const scriptFile = Bun.file("../data/server/loadscripts/join.lua")
		const script = buildLoadscript(await scriptFile.text(), {
			PLACE_ID: 0,
			SERVER_ADDRESS: "localhost",
			SERVER_PORT: 53640,
			USER_ID: 0,
			USERNAME: "Player1",
			MEMBERSHIP_TYPE: luaRaw(membershipType(0)),
			CHAR_APPEARANCE: "",
			PING_URL: "",
		})

		return new Response(await SignScript(script))
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
		PLACE_ID: luaRaw(toRawId(place.id)),
		SERVER_ADDRESS: serverHostname,
		SERVER_PORT: Number(serverPort),
		USER_ID: Math.floor(Math.random() * 1e9), // todo: tho not rly used 4 much atm
		USERNAME: user.username,
		MEMBERSHIP_TYPE: luaRaw(membershipType(user.permissionLevel)),
		CHAR_APPEARANCE: charApp,
		PING_URL: pingUrl,
	})

	return new Response(await SignScript(script))
}
