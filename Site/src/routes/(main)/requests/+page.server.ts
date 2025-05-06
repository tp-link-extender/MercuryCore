import { authorise } from "$lib/server/auth"
import pageQuery from "$lib/server/pageQuery"
import { Record, db } from "$lib/server/surreal"
import requestsQuery from "./requests.surql"

export async function load({ locals, url }) {
	const { user } = await authorise(locals)
	const { page, checkPages } = pageQuery(url)

	const [users, pages] = await db.query<[BasicUser[], number]>(
		requestsQuery,
		{ user: Record("user", user.id), page }
	)
	checkPages(pages)

	return { users, pages }
}
