import { error } from "@sveltejs/kit"
import { query, surql } from "$lib/server/surreal"

export async function GET({ url, request, setHeaders }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) throw error(400, "Invalid Request")
	if (request.headers.get("user-agent") != "Roblox/WinInet")
		throw error(400, "Invalid Request")

	await query(
		surql`
			UPDATE place SET serverPing = time::nano() / 1000000000
			WHERE serverTicket = $ticket`,
		{ ticket },
	)

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response("OK")
}
