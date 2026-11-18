import { authorise } from "#lib/server/auth.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import { db, Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import requestsQuery from "./requests.surql"

export async function load({ locals, url }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const { page, checkPages } = pageQuery(url)

	const [users, pages] = await db.query<[BasicUser[], number]>(
		requestsQuery,
		{ page, user: Record("user", user.id) }
	)
	checkPages(pages)

	return { pages, users }
}
