import { json } from "@sveltejs/kit"
import type { RequestEvent } from "./$types"

export async function GET({ params }: RequestEvent) {
	// get bearer token from header instead of insecure url (temporarily disabled)
	// const auth = request.headers.get("Authorization")
	// if (!auth || !auth.startsWith("Bearer ") || auth.slice(7) !== GAMESERVER_KEY)
	// 	error(403, "Unauthorised")

	const id = +params.id

	return json({
		ChatFilter: "whitelist",
	})
}
