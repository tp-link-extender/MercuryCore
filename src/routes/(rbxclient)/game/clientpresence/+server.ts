import { error } from "@sveltejs/kit"
import { playing } from "$lib/server/orm"

export async function GET({ url, request }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) error(400, "Invalid Request")
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	if (!(await playing.find(ticket))) error(400, "Ticket not found")

	playing.merge(ticket, {
		ping: Math.floor(Date.now() / 1000),
	})

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
