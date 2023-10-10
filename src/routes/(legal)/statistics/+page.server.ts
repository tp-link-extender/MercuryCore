import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { multiSquery } from "$lib/server/surreal"

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
	] = (await multiSquery(surql`
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
		LET $currency = (SELECT currency FROM user).currency;
		math::mean($currency);
		math::sum($currency)`)) as number[]

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
