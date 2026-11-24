import { catalogSearch } from "#lib/server/db/catalog.ts"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	const query = url.searchParams.get("q")?.trim()
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(Number(pageQ))
		? 1
		: Math.max(1, Math.round(Number(pageQ)))

	const assets = await catalogSearch(page, query)
	return Response.json(assets)
}
