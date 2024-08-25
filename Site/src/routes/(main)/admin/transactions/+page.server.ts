import { getAdminTransactions } from "$lib/server/economy"
import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	await authorise(locals, 5)

	// Awful no-good terrible code for transforming this stuff. Feels like we're back in the double-database days of Mercury 2

	const transactions = await getAdminTransactions()
	if (!transactions.ok) error(500, "Failed to fetch transactions")

	const list = transactions.value
	const users = new Set<string>()
	for (const tx of list) {
		if (tx.Type !== "Mint") users.add(tx.From)
		if (tx.Type !== "Burn") users.add(tx.To)
	}
	const usersList = Array.from(users).map(u => Record("user", u))
	const [queryUsers] = await equery<(BasicUser & { id: string })[][]>(surql`
		SELECT meta::id(id) AS id, status, username FROM ${usersList}`)

	const idsMap = new Map<string, BasicUser>()
	const usersMap = new Map<string, BasicUser>()
	for (const user of queryUsers) {
		idsMap.set(user.id, {
			username: user.username,
			status: user.status,
		})
		usersMap.set(user.username, {
			username: user.username,
			status: user.status,
		})
	}

	for (const tx of list) {
		if (tx.Type !== "Mint") tx.From = idsMap.get(tx.From)?.username || ""
		if (tx.Type !== "Burn") tx.To = idsMap.get(tx.To)?.username || ""
	}

	return {
		transactions: list,
		users: Object.fromEntries(usersMap),
	}
}
