import { json } from "@sveltejs/kit"
import { db } from "$lib/server/surreal"
import type { Asset } from "../+page.server"
import catalogQuery from "../catalog.surql"
import type { RequestEvent } from "./$types"

export async function GET({ url }: RequestEvent) {
	const query = url.searchParams.get("q")?.trim() as string
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(Number(pageQ)) ? 1 : Math.max(1, Math.round(Number(pageQ)))

	const [assets] = await db.query<Asset[][]>(catalogQuery, { page, query })
	return json(assets)
}
