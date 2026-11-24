import { error } from "@sveltejs/kit"
import { dbQuery } from "#lib/server/db/query.ts"
import { find } from "#lib/server/db/records.ts"
import { Record } from "#lib/server/surreal.ts"
import type { RequestEvent } from "./$types"
import pingQuery from "./ping.surql"

export async function GET({ request, url }: RequestEvent) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")
	if (!(await find("playing", ticket))) error(400, "Ticket not found")

	await dbQuery(pingQuery, { playing: Record("playing", ticket) })

	return new Response("OK", {
		headers: {
			"Cache-Control": "no-cache",
			Pragma: "no-cache",
		},
	})
}
