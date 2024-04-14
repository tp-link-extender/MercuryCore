import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import { query, squery, surql, findWhere } from "$lib/server/surreal"

type Session = {
	place: {
		id: number
		ownerUser: {
			number: number
		}
		serverIP: string
		serverPort: number
	}
	user: {
		number: number
		permissionLevel: number
		username: string
	}
}

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) error(400, "Invalid Request")

	const gameSession = await squery<Session>(
		surql`
			SELECT
				(SELECT
					meta::id(id) AS id,
					serverIP,
					serverPort,
					(SELECT number FROM <-owns<-user)[0] AS ownerUser
				FROM ->place)[0] AS place,
				(SELECT username, number, permissionLevel
				FROM <-user)[0] AS user
			FROM $playingId`,
		{ playingId: `playing:${clientTicket}` }
	)

	if (!gameSession) error(400, "Invalid Game Session")

	if (
		privateServer &&
		!(await findWhere("place", surql`privateTicket = $privateServer`, {
			privateServer,
		}))
	)
		error(400, "Invalid Private Server")

	await query(surql`UPDATE $playing SET valid = false`, {
		playing: `playing:${clientTicket}`,
	})

	const userNumber = gameSession.user.number
	const placeId = gameSession.place.id
	const creatorId = gameSession.place.ownerUser?.number || 0
	const charApp = `http://${process.env.DOMAIN}/asset/characterfetch?userID=${userNumber}`
	const pingUrl = `http://${process.env.DOMAIN}/game/clientpresence?ticket=${clientTicket}`

	const file = (await Bun.file("corescripts/processed/join.lua").text())
		.replaceAll("_PLACE_ID", placeId.toString())
		.replaceAll("_SERVER_ADDRESS", gameSession.place.serverIP)
		.replaceAll("_SERVER_PORT", gameSession.place.serverPort.toString())
		.replaceAll("_CREATOR_ID", creatorId.toString())
		.replaceAll("_USER_ID", userNumber.toString())
		.replaceAll("_USER_NAME", gameSession.user.username)
		.replaceAll(
			"_MEMBERSHIP_TYPE",
			`Enum.MembershipType.${gameSession.user.permissionLevel >= 2 ? "BuildersClub" : "None"}`
		)
		.replaceAll("_CHAR_APPEARANCE", charApp)
		.replaceAll("_PING_URL", pingUrl)

	return new Response(await SignData(file))
}
