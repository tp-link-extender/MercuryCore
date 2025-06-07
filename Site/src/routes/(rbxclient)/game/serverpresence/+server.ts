import { db } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import pingQuery from "./ping.surql"

export async function GET({ request, url }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) error(400, "Invalid Request")
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	await db.query(pingQuery, { ticket })

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
