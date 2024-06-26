import { Record, equery, find, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url, request }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) error(400, "Invalid Request")
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	if (!(await find("playing", ticket))) error(400, "Ticket not found")

	await equery(
		surql`UPDATE $ticket SET ping = ${Math.floor(Date.now() / 1000)}`,
		{ ticket: Record("playing", ticket) }
	)

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
