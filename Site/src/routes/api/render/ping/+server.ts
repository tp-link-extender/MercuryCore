import { error } from "@sveltejs/kit"
import { bearerMatches } from "#lib/server/bearer.ts"
import { pingRenderer } from "#lib/server/db/renders.ts"
import { RCC_KEY } from "$app/env/private"
import type { RequestEvent } from "./$types"

// TODO: this route isn't actually used for anything at the moment, the RCCService proxy should ping it "every so often"
export async function POST({ request }: RequestEvent) {
	if (!bearerMatches(request, RCC_KEY, "RCC_KEY")) error(403, "Nerd")

	await pingRenderer()
	return new Response()
}
