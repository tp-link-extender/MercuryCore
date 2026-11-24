import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { reportOf } from "#lib/server/db/moderation.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals, url }: PageServerLoadEvent) {
	await authorise(locals, 4)

	const associatedReport = url.searchParams.get("report")
	if (!associatedReport) return {}

	const report = await reportOf(associatedReport)
	if (!report) error(400, "Invalid report id")

	return { report }
}
