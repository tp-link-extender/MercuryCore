import { economyConnFailed, getBalance } from "$lib/server/economy"
import {
	getTransactions,
	transformTransactions,
} from "$lib/server/economy"
import { authorise } from "$lib/server/lucia"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	const balance = await getBalance(user.id)
	if (!balance.ok) error(500, economyConnFailed)

	const transactions = await getTransactions()
	if (!transactions.ok) error(500, "Failed to fetch transactions")

	return {
		balance: balance.value,
		...transformTransactions(transactions.value),
	}
}
