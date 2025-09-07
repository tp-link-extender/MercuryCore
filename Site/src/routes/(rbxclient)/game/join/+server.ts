import { error } from "@sveltejs/kit"
import config from "$lib/server/config"
import { db, findWhere, Record } from "$lib/server/surreal"
import joinQuery from "./join.surql"

type Session = {
	place: {
		id: number
		ownerUser: {
			username: string
		}
		serverAddress: string
		serverPort: number
	}
	user: {
		permissionLevel: number
		username: string
	}
}

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) error(400, "Invalid Request")

	const playing = Record("playing", clientTicket)
	const [[gameSession]] = await db.query<Session[][]>(joinQuery, { playing })
	if (!gameSession) error(400, "Invalid Game Session")

	const foundPrivatePlace = await findWhere(
		"place",
		"privateTicket = $privateServer",
		{ privateServer }
	)
	if (privateServer && !foundPrivatePlace)
		error(400, "Invalid Private Server")

	await db.merge(playing, { valid: false })

	const placeId = gameSession.place.id
	const creatorUsername = gameSession.place.ownerUser?.username
	const charApp = `http://${config.Domain}/asset/characterfetch/${gameSession.user.username}`
	const pingUrl = `http://${config.Domain}/game/clientpresence?ticket=${clientTicket}`
	const membershipType =
		gameSession.user.permissionLevel >= 2
			? "Enum.MembershipType.BuildersClub"
			: "Enum.MembershipType.None"

	const scriptFile = Bun.file("../Corescripts/join.lua")
	const script = (await scriptFile.text())
		.replaceAll("_PLACE_ID", `"${placeId.toString()}"`)
		.replaceAll("_SERVER_ADDRESS", gameSession.place.serverAddress)
		.replaceAll("_SERVER_PORT", gameSession.place.serverPort.toString())
		.replaceAll("_CREATOR_ID", creatorUsername)
		.replaceAll("_USER_ID", Math.floor(Math.random() * 1e9).toString()) // todo: tho not rly used 4 much atm
		.replaceAll("_USER_NAME", gameSession.user.username)
		.replaceAll("_MEMBERSHIP_TYPE", membershipType)
		.replaceAll("_CHAR_APPEARANCE", `"${charApp}"`)
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	return new Response(script)
}
