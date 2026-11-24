import { error } from "@sveltejs/kit"
import { pingServer } from "#lib/server/db/places.ts"
import type { RequestEvent } from "./$types"

export async function GET({ request, url }: RequestEvent) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	await pingServer(ticket)

	return new Response("OK", {
		headers: {
			"Cache-Control": "no-cache",
			Pragma: "no-cache",
		},
	})
}
