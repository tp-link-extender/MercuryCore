import { getBalance } from "$lib/server/economy"
import { authorise } from "$lib/server/lucia"

export async function load({ locals }) {
	const { user } = await authorise(locals)
	return { balance: await getBalance(user.id) }
}
