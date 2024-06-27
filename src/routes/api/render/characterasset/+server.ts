import { intRegex } from "$lib/paramTests"
import { error } from "@sveltejs/kit"

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !intRegex.test(id)) error(400, "Missing id parameter")

	const res = `${process.env.DOMAIN}/api/render/character;${process.env.DOMAIN}/asset?id=${id}`
	return new Response(res, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
