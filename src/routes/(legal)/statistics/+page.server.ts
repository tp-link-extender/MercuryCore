import { authorise } from "$lib/server/lucia"
import { equery } from "$lib/server/surreal"
import statisticsQuery from "./statistics.surql"

export async function load({ locals }) {
	await authorise(locals)

	const [
		users,
		places,
		groups,
		assets,
		transactions,
		friendships,
		followerships,
		statusPosts,
		forumPosts,
		forumReplies,
		,
		avgCurrency,
		totalCurrency,
	] = await equery<number[]>(statisticsQuery)

	return {
		users,
		places,
		groups,
		assets,
		transactions,
		friendships,
		followerships,
		statusPosts,
		forumPosts,
		forumReplies,
		avgCurrency,
		totalCurrency,
	}
}
