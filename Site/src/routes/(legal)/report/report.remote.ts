import { type } from "arktype"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "$lib/server/auth"
import { ratelimitRemote } from "$lib/server/ratelimit"
import { db, Record, type RecordId } from "$lib/server/surreal"
import type { ClientForm } from "$lib/validate"
import getReporteeQuery from "./getReportee.surql"
import reportQuery from "./report.surql"
import reports from "./reports"

const schema = type({
	category: type.enumerated(...reports).describe("a valid report category"),
	note: "string <= 1000",
})

async function getReportee(username: string) {
	const [[reportee]] = await db.query<{ id: RecordId<"user"> }[][]>(
		getReporteeQuery,
		{ username }
	)
	return reportee?.id
}

export const formData = form(schema, async ({ category, note }, issues) => {
	const { locals, url, getClientAddress } = getRequestEvent()
	const { user } = await authorise(locals)

	const username = url.searchParams.get("user")
	const reportUrl = url.searchParams.get("url")
	if (!username || !reportUrl) return issues("Missing fields")

	const reportee = await getReportee(username)
	if (!reportee) return issues("Invalid user")

	const limit = ratelimitRemote(issues, "report", getClientAddress, 120)
	if (limit) return limit

	await db.query(reportQuery, {
		user: Record("user", user.id),
		reportee,
		note: note?.trim(),
		reportUrl,
		category,
	})

	return { success: "Report sent successfully." }
}) as ClientForm<typeof schema.infer>
