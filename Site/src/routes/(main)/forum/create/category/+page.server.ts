import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"

export async function load({ locals }) {
	exclude("Forum")
	await authorise(locals, 5)
}
