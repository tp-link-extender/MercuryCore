import { error } from "@sveltejs/kit"
import { SignData } from "$lib/server/sign"
import { prisma } from "$lib/server/prisma"
import fs from "fs"

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	let isStudioJoin = false
	// let joinMethod = "Studio"

	if (!clientTicket) {
		// joinMethod = "Studio"
		isStudioJoin = true
		throw error(400, "Invalid Request")
	} //else joinMethod = "Ticket"

	let serverAddress = "localhost"
	let serverPort = 53640
	let userName = "Player"
	let userId = 0
	let placeId = -1
	let creatorId = 0
	let MembershipType = "None"
	let charApp = "http://banland.xyz/asset/characterfetch?userID=0"
	let pingUrl = ""

	// if ((joinMethod = "Ticket")) {
	const gameSession = (
		await prisma.gameSessions.findMany({
			where: { ticket: clientTicket, valid: true },
			include: {
				user: true,
				place: {
					include: {
						ownerUser: true,
						ownerGroup: true,
					},
				},
			},
		})
	)[0]
	if (!gameSession) throw error(400, "Invalid Game Session")

	await prisma.gameSessions.update({
		where: {
			ticket: clientTicket,
		},
		data: {
			valid: false,
		},
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
	placeId = gameSession.place.id
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
