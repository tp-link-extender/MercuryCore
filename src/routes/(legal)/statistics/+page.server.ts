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
		count(SELECT * FROM user);
		count(SELECT * FROM place);
		count(SELECT * FROM group);
		count(SELECT * FROM asset);
		count(SELECT * FROM transaction);
		count(SELECT * FROM friends);
		count(SELECT * FROM follows);
		count(SELECT * FROM statusPost);
		count(SELECT * FROM forumPost);
		count(SELECT * FROM forumReply);
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
