import { error } from "@sveltejs/kit"
import { prisma } from "$lib/server/prisma"

export async function GET({ url, request }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket || request.headers.get("user-agent") != "Roblox/WinInet") throw error(400, "Invalid Request")

	await prisma.place.update({
		where: { serverTicket: ticket },
		data: { serverPing: Date.now() },
	})

	return new Response("OK")
}
