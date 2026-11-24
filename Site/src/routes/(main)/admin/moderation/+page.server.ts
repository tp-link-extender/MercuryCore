import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import assocreportQuery from "./assocreport.surql"

export async function load({ locals, url }: PageServerLoadEvent) {
	await authorise(locals, 4)

	const associatedReport = url.searchParams.get("report")
	if (!associatedReport) return {}

	const [report] = await dbQuery<
		({ note: string; reportee: string } | undefined)[]
	>(assocreportQuery, {
		report: Record("report", associatedReport),
	})
	if (!report) error(400, "Invalid report id")

	return { report }
}
