import surql from "$lib/surrealtag"
import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import { prisma } from "$lib/server/prisma"
import surreal, { squery } from "$lib/server/surreal"
import fs from "fs"

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket"),
		privateServer = url.searchParams.get("privateServer") as string,
		playingId = `playing:${clientTicket}`

	let isStudioJoin = false
	// let joinMethod = "Studio"

	if (!clientTicket) {
		// joinMethod = "Studio"
		isStudioJoin = true
		throw error(400, "Invalid Request")
	} //else joinMethod = "Ticket"

	let serverAddress = "localhost",
		serverPort = 53640,
		userName = "Player",
		userId = 0,
		placeId = -1,
		creatorId = 0,
		MembershipType = "None",
		charApp = "http://banland.xyz/asset/characterfetch?userID=0",
		pingUrl = ""

	// if ((joinMethod = "Ticket")) {
	const gameSession = (await squery(
		surql`
			SELECT
				(SELECT
					serverIP,
					serverPort,
					id,
					(SELECT number FROM <-owns<-user)[0] AS ownerUser
				FROM ->place)[0] AS place,
				(SELECT
					username,
					number,
					permissionLevel
				FROM <-user)[0] AS user
			FROM $playingId
		`,
		{ playingId },
	)) as {
		place: {
			id: string
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

	if (!gameSession) throw error(400, "Invalid Game Session")

	await surreal.update(`playing:${clientTicket}`, {
		valid: false,
	})

	if (privateServer) {
		const privateSession = await prisma.place.findUnique({
			where: { privateTicket: privateServer },
		})

		if (!privateSession) throw error(400, "Invalid Private Server")
	}

	serverAddress = gameSession.place.serverIP
	serverPort = gameSession.place.serverPort
	userName = gameSession.user.username
	userId = gameSession.user.number
	placeId = parseInt(gameSession.place.id.split(":")[1])
	creatorId = gameSession.place.ownerUser?.number || 0
	charApp = `http://banland.xyz/asset/characterfetch?userID=${userId}`
	pingUrl = `http://banland.xyz/game/clientpresence?ticket=${clientTicket}`

	if (gameSession.user.permissionLevel == 2) MembershipType = "BuildersClub"
	// }

	return new Response(
		SignData(
			fs
				.readFileSync(`corescripts/processed/join.lua`, "utf-8")
				.replaceAll("_PLACE_ID", placeId.toString())
				.replaceAll("_IS_STUDIO_JOIN", isStudioJoin.toString())
				.replaceAll("_SERVER_ADDRESS", serverAddress)
				.replaceAll("_SERVER_PORT", serverPort.toString())
				.replaceAll("_CREATOR_ID", creatorId.toString())
				.replaceAll("_USER_ID", userId.toString())
				.replaceAll("_USER_NAME", userName)
				.replaceAll("_MEMBERSHIP_TYPE", MembershipType)
				.replaceAll("_CHAR_APPEARANCE", charApp)
				.replaceAll("_PING_URL", pingUrl),
		),
	)
}
