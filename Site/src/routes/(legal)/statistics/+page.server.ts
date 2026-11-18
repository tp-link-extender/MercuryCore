import { authorise } from "#lib/server/auth.ts"
import exclude from "#lib/server/exclude.ts"
import { db } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import statisticsQuery from "./statistics.surql"

export async function load({ locals }: PageServerLoadEvent) {
	exclude("Statistics")
	await authorise(locals)

	return { stats: await db.query<number[]>(statisticsQuery) }
}
