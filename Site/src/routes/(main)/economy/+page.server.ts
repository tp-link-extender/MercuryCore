import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import {
	economyConnFailed,
	getBalance,
	getTransactions,
	transformTransactions,
} from "$lib/server/economy"

export async function load({ fetch: f, locals }) {
	const { user } = await authorise(locals)

	const b = await getBalance(f, user.id)
	if (!b.ok) error(500, economyConnFailed)

	const transactions = await getTransactions(f, user.id)
	if (!transactions.ok) error(500, "Failed to fetch transactions")

	return {
		balance: b.value,
		...(await transformTransactions(transactions.value)),
	}
}
