import { type } from "arktype"
import { reportPath } from "#lib/reportUrl.ts"
import { authorise } from "#lib/server/auth.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { db, Record, type RecordId } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import getReporteeQuery from "./getReportee.surql"
import reportQuery from "./report.surql"
import reports from "./reports"

const schema = type({
	category: type.enumerated(...reports).describe("a valid report category"),
	"note?": "string <= 1000",
})

async function getReportee(username: string) {
	const [[reportee]] = await db.query<{ id: RecordId<"user"> }[][]>(
		getReporteeQuery,
		{ username }
	)
	return reportee?.id
}

export const formData: ClientForm<typeof schema.infer> = form(
	schema,
	async ({ category, note }, issues) => {
		const { locals, url, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals)

		const username = url.searchParams.get("user")
		const rawReportUrl = url.searchParams.get("url")
		if (!username || !rawReportUrl) return issues("Missing fields")

		const reportUrl = reportPath(rawReportUrl)
		if (!reportUrl) return issues("Invalid report URL")

		const reportee = await getReportee(username)
		if (!reportee) return issues("Invalid user")

		const limit = ratelimitRemote(issues, "report", getClientAddress, 120)
		if (limit) return limit

		await db.query(reportQuery, {
			category,
			note: note?.trim(),
			reportee,
			reportUrl,
			user: Record("user", user.id),
		})

		return { success: "Report sent successfully." }
	}
)
