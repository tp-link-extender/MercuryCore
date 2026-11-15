import { error } from "@sveltejs/kit"
import { reportPath } from "$lib/reportUrl"
import { authorise } from "$lib/server/auth"
import { db, type RecordId } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import getReporteeQuery from "./getReportee.surql"

async function getReportee(
	username: string
): Promise<RecordId<"user"> | undefined> {
	const [[reportee]] = await db.query<{ id: RecordId<"user"> }[][]>(
		getReporteeQuery,
		{ username }
	)
	return reportee?.id
}

export async function load({ locals, url }: PageServerLoadEvent) {
	await authorise(locals)

	const reportee = url.searchParams.get("user")
	const rawReportUrl = url.searchParams.get("url")
	if (!reportee || !rawReportUrl) error(400, "Missing user or url parameters")

	const reportedUrl = reportPath(rawReportUrl)
	if (!reportedUrl) error(400, "Invalid report URL")

	const reporteeUser = await getReportee(reportee)
	if (!reporteeUser) error(400, "Invalid user")

	return {
		reportee,
		url: reportedUrl,
	}
}
