import { error } from "@sveltejs/kit"
import { dbQuery } from "#lib/server/db/query.ts"
import type { RequestEvent } from "./$types"
import pingQuery from "./ping.surql"

export async function GET({ request, url }: RequestEvent) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket")
	if (!ticket) error(400, "Invalid Request")

	await dbQuery(pingQuery, { ticket })

	return new Response("OK", {
		headers: {
			"Cache-Control": "no-cache",
			Pragma: "no-cache",
		},
	})
}
