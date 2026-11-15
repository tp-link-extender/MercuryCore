import { authorise } from "$lib/server/auth"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 3)
}
