import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import { db, type RecordId } from "$lib/server/surreal"
import getReporteeQuery from "./getReportee.surql"

async function getReportee(username: string) {
	const [[reportee]] = await db.query<{ id: RecordId<"user"> }[][]>(
		getReporteeQuery,
		{ username }
	)
	return reportee.id
}

export async function load({ locals, url }) {
	await authorise(locals)

	const reportee = url.searchParams.get("user")
	const reportedUrl = url.searchParams.get("url")
	if (!reportee || !reportedUrl) error(400, "Missing user or url parameters")

	const reporteeUser = await getReportee(reportee)
	if (!reporteeUser) error(400, "Invalid user")

	return {
		reportee,
		url: reportedUrl,
	}
}
