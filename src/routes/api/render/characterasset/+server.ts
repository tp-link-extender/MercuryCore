import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) throw error(400, "Missing id parameter")

	const rccOrigin = process.env.RCC_ORIGIN,
		res = `${rccOrigin}/api/render/character;${rccOrigin}/asset?id=${id}`

	console.log("res", res)

	return new Response(res, {
		headers: {
			Pragma: "no-cache",
			"Cache-Control": "no-cache",
		},
	})
}
