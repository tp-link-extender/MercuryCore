import { error } from "@sveltejs/kit"
import surreal from "$lib/server/surreal"

export async function GET({ url, request }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) throw error(400, "Invalid Request")
	if (request.headers.get("user-agent") != "Roblox/WinInet")
		throw error(400, "Good one")

	if (!(await surreal.select(`playing:${ticket}`))[0])
		throw error(400, "Ticket not found")

	surreal.merge(`playing:${ticket}`, {
		ping: Math.floor(Date.now() / 1000),
	})

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
