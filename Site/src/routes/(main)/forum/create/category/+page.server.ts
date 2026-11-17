import { authorise } from "#lib/server/auth.ts"
import exclude from "#lib/server/exclude.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	exclude("Forum")
	await authorise(locals, 5)
}
