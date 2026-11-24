import { authorise } from "#lib/server/auth.ts"
import { siteStatistics } from "#lib/server/db/statistics.ts"
import exclude from "#lib/server/exclude.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	exclude("Statistics")
	await authorise(locals)

	return { stats: await siteStatistics() }
}
