import { authorise } from "$lib/server/lucia"
import { mquery } from "$lib/server/surreal"

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
	] = await mquery<number[]>(import("./statistics.surql"))

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
