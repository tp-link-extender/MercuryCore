import { error } from "@sveltejs/kit"
import surreal from "$lib/server/surreal"

export async function GET({ url, request, setHeaders }) {
	const ticket = url.searchParams.get("ticket") as string

	if (!ticket) throw error(400, "Invalid Request")
	if (request.headers.get("user-agent") != "Roblox/WinInet")
		throw error(400, "Invalid Request")

	surreal.update(`playing:${ticket}`, {
		ping: Math.floor(Date.now() / 1000),
	})

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response("OK")
}
