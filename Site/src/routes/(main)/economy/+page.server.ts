import { error } from "@sveltejs/kit"
import { balance, historyOwner } from "economy/api"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import { economyConnFailed, ownerData } from "$lib/server/economy"

export async function load({ fetch: f, locals }) {
	const { user } = await authorise(locals)

	const u = new Econ.User(user.id)
	const b = await balance(f, u) // fu
	if (!b.ok) error(500, economyConnFailed)

	const transactions = await historyOwner(f, 100, u)
	if (!transactions.ok) error(500, "Failed to fetch transactions")

	return {
		balance: b.value,
		transactions: transactions.value.map(t => t.Serialise()),
		ownerData: await ownerData(transactions.value),
	}
}
