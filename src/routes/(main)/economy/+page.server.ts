import { getBalance } from "$lib/server/economy"
import { authorise } from "$lib/server/lucia"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	const { user } = await authorise(locals)
	try {
		return { balance: await getBalance(user.id) }
	} catch {
		error(500, "Cannot connect to economy service")
	}
}
