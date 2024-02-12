import { authorise } from "$lib/server/lucia"
import { mquery, surql } from "$lib/server/surreal"

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
	] = await mquery<number[]>(surql`
		count(SELECT 1 FROM user);
		count(SELECT 1 FROM place);
		count(SELECT 1 FROM group);
		count(SELECT 1 FROM asset);
		count(SELECT 1 FROM transaction);
		count(SELECT 1 FROM friends);
		count(SELECT 1 FROM follows);
		count(SELECT 1 FROM statusPost);
		count(SELECT 1 FROM forumPost);
		count(SELECT 1 FROM forumReply);
		LET $currency = (SELECT currency FROM user WHERE number != 1).currency;
		math::mean($currency);
		math::sum($currency)`)

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
