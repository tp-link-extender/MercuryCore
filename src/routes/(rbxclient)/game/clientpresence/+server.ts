import { Record, equery, find, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url, request }) {
	if (request.headers.get("user-agent") !== "Roblox/WinInet")
		error(400, "Good one")

	const ticket = url.searchParams.get("ticket") as string
	if (!ticket) error(400, "Invalid Request")
	if (!(await find("playing", ticket))) error(400, "Ticket not found")

	await equery(
		surql`UPDATE ${Record("playing", ticket)} SET ping = time::now()`
	)

	return new Response("OK", {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
