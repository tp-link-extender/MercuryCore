import { error } from "@sveltejs/kit"
import { pingClient } from "#lib/server/db/playing.ts"
import { find } from "#lib/server/db/records.ts"
import type { RequestEvent } from "./$types"

export async function GET({ request, url }: RequestEvent) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")
	if (!(await find("playing", ticket))) error(400, "Ticket not found")

	await pingClient(ticket)

	return new Response("OK", {
		headers: {
			"Cache-Control": "no-cache",
			Pragma: "no-cache",
		},
	})
}
