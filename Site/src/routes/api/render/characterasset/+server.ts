import { intRegex } from "$lib/paramTests"
import config from "$lib/server/config"
import { error } from "@sveltejs/kit"

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !intRegex.test(id)) error(400, "Missing id parameter")

	const res = `${config.Domain}/api/render/character;${config.Domain}/asset?id=${id}`
	return new Response(res, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
