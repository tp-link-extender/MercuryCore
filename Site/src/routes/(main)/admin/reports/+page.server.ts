import { authorise } from "#lib/server/auth.ts"
import { reportsOf } from "#lib/server/db/reports.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const reports = await reportsOf()
	return { reports }
}
