import { SignData } from "$lib/server/sign"
import { Record, equery, findWhere, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import joinQuery from "./join.surql"

type Session = {
	place: {
		id: number
		ownerUser: {
			username: string
		}
		serverIP: string
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
	const [[gameSession]] = await equery<Session[][]>(joinQuery, { playing })
	if (!gameSession) error(400, "Invalid Game Session")

	const foundPrivatePlace = await findWhere(
		"place",
		"privateTicket = $privateServer",
		{ privateServer }
	)
	if (privateServer && !foundPrivatePlace)
		error(400, "Invalid Private Server")

	await equery(surql`UPDATE ${playing} SET valid = false`)

	const placeId = gameSession.place.id
	const creatorUsername = gameSession.place.ownerUser?.username
	const charApp = `http://${process.env.DOMAIN}/asset/characterfetch/${gameSession.user.username}`
	const pingUrl = `http://${process.env.DOMAIN}/game/clientpresence?ticket=${clientTicket}`
	const membershipType =
		gameSession.user.permissionLevel >= 2
			? "Enum.MembershipType.BuildersClub"
			: "Enum.MembershipType.None"

	const file = (await Bun.file("corescripts/processed/join.lua").text())
		.replaceAll("_PLACE_ID", placeId.toString())
		.replaceAll("_SERVER_ADDRESS", gameSession.place.serverIP)
		.replaceAll("_SERVER_PORT", gameSession.place.serverPort.toString())
		.replaceAll("_CREATOR_ID", creatorUsername)
		.replaceAll("_USER_ID", Math.floor(Math.random() * 1e9).toString()) // todo: tho not rly used 4 much atm
		.replaceAll("_USER_NAME", gameSession.user.username)
		.replaceAll("_MEMBERSHIP_TYPE", membershipType)
		.replaceAll("_CHAR_APPEARANCE", charApp)
		.replaceAll("_PING_URL", pingUrl)

	return new Response(await SignData(file))
}
