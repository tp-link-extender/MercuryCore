import { equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url, request }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) error(400, "Invalid Request")
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	await equery(
		surql`
			UPDATE place SET serverPing = time::unix()
			WHERE serverTicket = ${ticket}`
	)

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
