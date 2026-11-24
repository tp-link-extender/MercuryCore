import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import requestsQuery from "./requests.surql"

export async function load({ locals, url }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const { page, checkPages } = pageQuery(url)

	const [users, pages] = await dbQuery<[BasicUser[], number]>(requestsQuery, {
		page,
		user: Record("user", user.id),
	})
	checkPages(pages)

	return { pages, users }
}
