import { authorise } from "$lib/server/lucia"
import pageQuery from "$lib/server/pageQuery"
import { Record, equery } from "$lib/server/surreal"
import requestsQuery from "./requests.surql"

export async function load({ locals, url }) {
	const { user } = await authorise(locals)
	const { page, checkPages } = pageQuery(url)

	const [users, pages] = await equery<[BasicUser[], number]>(requestsQuery, {
		user: Record("user", user.id),
		page,
	})
	checkPages(pages)

	return { users, pages }
}
