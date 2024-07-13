import { getBalance } from "$lib/server/economy"
import { authorise } from "$lib/server/lucia"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	const balance = await getBalance(user.id)
	if (!balance.ok) error(500, "Cannot connect to economy service")
	return { balance: balance.value }
}
