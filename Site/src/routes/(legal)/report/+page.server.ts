import { error } from "@sveltejs/kit"
import { reportPath } from "#lib/reportUrl.ts"
import { authorise } from "#lib/server/auth.ts"
import { reporteeOf } from "#lib/server/db/moderation.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals, url }: PageServerLoadEvent) {
	await authorise(locals)

	const reportee = url.searchParams.get("user")
	const rawReportUrl = url.searchParams.get("url")
	if (!reportee || !rawReportUrl) error(400, "Missing user or url parameters")

	const reportedUrl = reportPath(rawReportUrl)
	if (!reportedUrl) error(400, "Invalid report URL")

	const reporteeUser = await reporteeOf(reportee)
	if (!reporteeUser) error(400, "Invalid user")

	return {
		reportee,
		url: reportedUrl,
	}
}
