import { error } from "@sveltejs/kit"
import "dotenv/config"

export async function GET({ url, setHeaders }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) throw error(400, "Missing assetId parameter")

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response(`${process.env.RCC_ORIGIN}/api/render/character;${process.env.RCC_ORIGIN}/Asset?id=${id}`)
}
