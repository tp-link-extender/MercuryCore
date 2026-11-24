import { dbQuery } from "#lib/server/db/query.ts"
import type { Asset } from "../+page.server"
import catalogQuery from "../catalog.surql"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	const query = url.searchParams.get("q")?.trim()
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(Number(pageQ))
		? 1
		: Math.max(1, Math.round(Number(pageQ)))

	const [assets] = await dbQuery<Asset[][]>(catalogQuery, { page, query })
	return Response.json(assets)
}
