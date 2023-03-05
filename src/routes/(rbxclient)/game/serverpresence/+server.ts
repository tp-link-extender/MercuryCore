import { error } from "@sveltejs/kit"
import type { RequestHandler } from "./$types"
import { prisma } from "$lib/server/prisma"

export const GET: RequestHandler = async ({ url, request }) => {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket || request.headers.get("user-agent") != "Roblox/WinInet") throw error(400, "Invalid Request")

	await prisma.place.update({
		where: { serverTicket: ticket },
		data: { serverPing: Date.now() },
	})

	return new Response("OK")
}
