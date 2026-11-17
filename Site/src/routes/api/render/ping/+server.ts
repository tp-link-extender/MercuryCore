import { error } from "@sveltejs/kit"
import { bearerMatches } from "#lib/server/bearer.ts"
import { db } from "#lib/server/surreal.ts"
import { RCC_KEY } from "$app/env/private"
import type { RequestEvent } from "./$types"
import pingQuery from "./ping.surql"

// TODO: this route isn't actually used for anything at the moment, the RCCService proxy should ping it "every so often"
export async function POST({ request }: RequestEvent) {
	if (!bearerMatches(request, RCC_KEY, "RCC_KEY")) error(403, "Nerd")

	await db.query(pingQuery)
	return new Response()
}
