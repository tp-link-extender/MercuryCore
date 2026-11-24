import { authorise } from "#lib/server/auth.ts"
import { requestsOf } from "#lib/server/db/social.ts"
import pageQuery from "#lib/server/pageQuery.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals, url }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const { page, checkPages } = pageQuery(url)

	const { pages, users } = await requestsOf(Record("user", user.id), page)
	checkPages(pages)

	return { pages, users }
}
