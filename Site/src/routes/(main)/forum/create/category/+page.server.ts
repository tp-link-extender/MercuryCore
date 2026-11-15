import { authorise } from "$lib/server/auth"
import exclude from "$lib/server/exclude"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	exclude("Forum")
	await authorise(locals, 5)
}
