import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import surreal, { squery, surql } from "$lib/server/surreal"
import fs from "fs"

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) error(400, "Invalid Request")

	const gameSession = await squery<{
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
	}>(
		surql`
			SELECT
				(SELECT
					meta::id(id) AS id,
					serverIP,
					serverPort,
					(SELECT number FROM <-owns<-user)[0] AS ownerUser
				FROM ->place)[0] AS place,
				(SELECT
					username,
					number,
					permissionLevel
				FROM <-user)[0] AS user
			FROM $playingId`,
		{ playingId: `playing:${clientTicket}` }
	)

	if (!gameSession) error(400, "Invalid Game Session")

	if (privateServer) {
		const privateSession = await squery(
			surql`
				SELECT * FROM place
				WHERE privateTicket = $privateServer`,
			{ privateServer }
		)

		if (!privateSession) error(400, "Invalid Private Server")
	}

	await surreal.merge(`playing:${clientTicket}`, {
		valid: false,
	})

	const userNumber = gameSession.user.number
	const placeId = gameSession.place.id
	const creatorId = gameSession.place.ownerUser?.number || 0
	const charApp = `http://banland.xyz/asset/characterfetch?userID=${userNumber}`
	const pingUrl = `http://banland.xyz/game/clientpresence?ticket=${clientTicket}`

	const file = fs
		.readFileSync("corescripts/processed/join.lua", "utf-8")
		.replaceAll("_PLACE_ID", placeId.toString())
		.replaceAll("_SERVER_ADDRESS", gameSession.place.serverIP)
		.replaceAll("_SERVER_PORT", gameSession.place.serverPort.toString())
		.replaceAll("_CREATOR_ID", creatorId.toString())
		.replaceAll("_USER_ID", userNumber.toString())
		.replaceAll("_USER_NAME", gameSession.user.username)
		.replaceAll(
			"_MEMBERSHIP_TYPE",
			gameSession.user.permissionLevel >= 2 ? "BuildersClub" : "None"
		)
		.replaceAll("_CHAR_APPEARANCE", `"${charApp}"`)
		.replaceAll("_PING_URL", `"${pingUrl}"`)

	return new Response(SignData(file))
}
