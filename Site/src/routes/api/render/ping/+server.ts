import { error } from "@sveltejs/kit"
import { RCC_KEY } from "$env/static/private"
import { db } from "$lib/server/surreal"
import pingQuery from "./ping.surql"

// TODO: this route isn't actually used for anything at the moment, the RCCService proxy should ping it "every so often"
export async function POST({ request }) {
	const auth = request.headers.get("Authorization")
	if (!auth || !auth.startsWith("Bearer ") || auth.slice(7) !== RCC_KEY)
		throw error(403, "Nerd")

	await db.query(pingQuery)
	return new Response()
}
