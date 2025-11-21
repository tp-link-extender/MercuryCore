import { error } from "@sveltejs/kit"
import { membershipType } from "$lib/permissionLevels"
import config from "$lib/server/config"
import idToPort from "$lib/server/idToPort"
import { SignData } from "$lib/server/sign"
import { db, findWhere, Record } from "$lib/server/surreal"
import joinQuery from "./join.surql"

type Session = {
	place: {
		id: number
		ownerUser: {
			username: string
		}
		dedicated: boolean
		serverAddress: string
		serverPort: number
	}
	user: {
		permissionLevel: number
		username: string
	}
}

const serverDedicated = (dedicated: boolean) =>
	config.Gameservers.Hosting === "Both"
		? dedicated
		: config.Gameservers.Hosting === "Dedicated"

const serverInfo = (place: Session["place"]) =>
	serverDedicated(place.dedicated)
		? {
				serverAddress: config.OrbiterPublicURL,
				serverPort: idToPort(place.id),
			}
		: place

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) error(400, "Invalid Request")

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
	const { serverAddress, serverPort } = serverInfo(place)

	const creatorUsername = place.ownerUser?.username
	const charApp = `http://${config.Domain}/asset/characterfetch/${user.username}`
	const pingUrl = `http://${config.Domain}/game/clientpresence?ticket=${clientTicket}`
	const scriptFile = Bun.file("../data/server/loadscripts/join.lua")
	const script = (await scriptFile.text())
		.replaceAll("_PLACE_ID", place.id.toString())
		.replaceAll("_SERVER_ADDRESS", serverAddress) // TODO: quote
		.replaceAll("_SERVER_PORT", serverPort.toString())
		.replaceAll("_CREATOR_ID", creatorUsername)
		.replaceAll("_USER_ID", Math.floor(Math.random() * 1e9).toString()) // todo: tho not rly used 4 much atm
		.replaceAll("_USER_NAME", user.username)
		.replaceAll("_MEMBERSHIP_TYPE", membershipType(user.permissionLevel))
		.replaceAll("_CHAR_APPEARANCE", `"${charApp}"`)
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	return new Response(await SignData(script))
}
