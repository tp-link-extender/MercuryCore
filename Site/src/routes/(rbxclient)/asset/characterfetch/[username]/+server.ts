import { error } from "@sveltejs/kit"
import config from "#lib/server/config.ts"
import { wornAssetsOf } from "#lib/server/db/appearance.ts"
import type { RequestEvent } from "./$types"

export async function GET({ params }: RequestEvent) {
	const { username } = params
	const wearing = await wornAssetsOf(username)
	if (!wearing) error(404, "User not found")

	let charApp = `http://${config.DomainInsecure}/asset/bodycolors.ashx?username=${username}`
	for (const asset of wearing)
		charApp += `;https://${config.Domain}/asset?id=${asset}`

	return new Response(charApp, {
		headers: {
			"Cache-Control": "no-cache",
			"Content-Type": "text/plain",
			Pragma: "no-cache",
		},
	})
}
