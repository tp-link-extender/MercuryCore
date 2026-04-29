import { error } from "@sveltejs/kit"
import { membershipType } from "$lib/permissionLevels"
import config from "$lib/server/config"
import idToPort, { proxyOffset } from "$lib/server/idToPort"
import { SignData } from "$lib/server/sign"
import { db, findWhere, Record } from "$lib/server/surreal"
import joinQuery from "./join.surql"

type ServerAddress = {
	serverHostname: string
	serverPort: number
}

type Session = {
	place: {
		id: number
		ownerUser: {
			username: string
		}
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
		const script = (await scriptFile.text())
			.replaceAll("_PLACE_ID", "0")
			.replaceAll("_SERVER_ADDRESS", `"localhost"`)
			.replaceAll("_SERVER_PORT", "53640")
			.replaceAll("_USER_ID", "0")
			.replaceAll("_USERNAME", `"Player1"`)
			.replaceAll("_MEMBERSHIP_TYPE", membershipType(0))
			.replaceAll("_CHAR_APPEARANCE", `""`)
			.replaceAll("_PING_URL", `""`)

		return new Response(await SignData(script))
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

	// const creatorUsername = place.ownerUser?.username;
	const charApp = `http://${config.DomainInsecure}/asset/characterfetch/${user.username}`
	const pingUrl = `http://${config.DomainInsecure}/game/clientpresence?ticket=${clientTicket}`
	const scriptFile = Bun.file("../data/server/loadscripts/join.lua")
	const script = (await scriptFile.text())
		.replaceAll("_PLACE_ID", place.id.toString())
		.replaceAll("_SERVER_ADDRESS", `"${serverHostname}"`)
		.replaceAll("_SERVER_PORT", serverPort.toString())
		// .replaceAll("_CREATOR_ID", creatorUsername)
		.replaceAll("_USER_ID", Math.floor(Math.random() * 1e9).toString()) // todo: tho not rly used 4 much atm
		.replaceAll("_USERNAME", `"${user.username}"`)
		.replaceAll("_MEMBERSHIP_TYPE", membershipType(user.permissionLevel))
		.replaceAll("_CHAR_APPEARANCE", `"${charApp}"`)
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	return new Response(await SignData(script))
}
