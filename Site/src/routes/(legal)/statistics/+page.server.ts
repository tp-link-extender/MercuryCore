import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import exclude from "#lib/server/exclude.ts"
import type { PageServerLoadEvent } from "./$types"
import statisticsQuery from "./statistics.surql"

export async function load({ locals }: PageServerLoadEvent) {
	exclude("Statistics")
	await authorise(locals)

	return { stats: await dbQuery<number[]>(statisticsQuery) }
}
