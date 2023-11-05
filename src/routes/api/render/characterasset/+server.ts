import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url, setHeaders }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) throw error(400, "Missing id parameter")

	const apiKey = url.searchParams.get("apiKey"),
		rccOrigin = process.env.RCC_ORIGIN

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	console.log("got api key", apiKey)

	const res =
		`${rccOrigin}/api/render/character;${rccOrigin}/asset?id=${id}` +
		(apiKey ? `&apiKey=${apiKey}` : "")

	console.log("res", res)

	return new Response(res)
}
