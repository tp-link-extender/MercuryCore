import { error } from "@sveltejs/kit"
import { prisma } from "$lib/server/prisma"

export async function GET({ url, request, setHeaders }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) throw error(400, "Invalid Request")
	if (request.headers.get("user-agent") != "Roblox/WinInet") throw error(400, "Invalid Request")

	await prisma.gameSessions.update({
		where: { ticket: ticket },
		data: { ping: Math.floor(Date.now() / 1000) },
	})

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response("OK")
}
