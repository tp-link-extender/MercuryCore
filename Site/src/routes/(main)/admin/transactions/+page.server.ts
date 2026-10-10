import { error } from "@sveltejs/kit"
import { history } from "economy/api"
import { authorise } from "$lib/server/auth"
import { economyConnFailed, ownerData } from "$lib/server/economy"

export async function load({ fetch: f, locals }) {
	await authorise(locals, 5)

	const transactions = await history(f, 100)
	if (!transactions.ok) error(500, economyConnFailed)

	return {
		transactions: transactions.value.map(t => t.Serialise()),
		ownerData: await ownerData(transactions.value),
	}
}
