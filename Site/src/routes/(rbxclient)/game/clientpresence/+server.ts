import { Record, db, find } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import pingQuery from "./ping.surql"

export async function GET({ url, request }) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket") as string
	if (!ticket) error(400, "Invalid Request")
	if (!(await find("playing", ticket))) error(400, "Ticket not found")

	await db.query(pingQuery, { playing: Record("playing", ticket) })

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
