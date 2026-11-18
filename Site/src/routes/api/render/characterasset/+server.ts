import { error } from "@sveltejs/kit"
import { assetRegex } from "#lib/paramTests.ts"
import config from "#lib/server/config.ts"
import type { RequestEvent } from "./$types"

export function GET({ url }: RequestEvent) {
	const id = url.searchParams.get("id")
	if (!id || !assetRegex.test(id)) error(400, "Missing id parameter")

	const res = `http://${config.DomainInsecure}/asset/bodycolors.ashx?;http://${config.Domain}/asset?id=${id}`
	return new Response(res, {
		headers: {
			"Cache-Control": "no-cache",
			Pragma: "no-cache",
		},
	})
}
