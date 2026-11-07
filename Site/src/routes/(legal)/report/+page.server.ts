import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { reportPath } from "$lib/reportUrl"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record, type RecordId } from "$lib/server/surreal"
import {
	arktype,
	errMessage,
	message,
	superValidate,
} from "$lib/server/validate"
import type { Actions, PageServerLoadEvent } from "./$types"
import getReporteeQuery from "./getReportee.surql"
import reportQuery from "./report.surql"
import reports from "./reports"

const schema = type({
	category: type.enumerated(...reports).describe("a valid report category"),
	note: "string | undefined",
})

async function getReportee(username: string) {
	const [[reportee]] = await db.query<{ id: RecordId<"user"> }[][]>(
		getReporteeQuery,
		{ username }
	)
	return reportee.id
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
		form: await superValidate(arktype(schema)),
		reportee,
		url: reportedUrl,
	}
}

export const actions: Actions = {}
actions.default = async ({ locals, request, url, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { category, note } = form.data
	const username = url.searchParams.get("user")
	const rawReportUrl = url.searchParams.get("url")
	if (!username || !rawReportUrl) error(400, "Missing fields")

	const reportUrl = reportPath(rawReportUrl)
	if (!reportUrl) error(400, "Invalid report URL")

	const reportee = await getReportee(username)
	if (!reportee) return errMessage(form, "Invalid user")

	const limit = ratelimit(form, "report", getClientAddress, 120)
	if (limit) return limit

	await db.query(reportQuery, {
		category,
		note,
		reportee,
		reportUrl,
		user: Record("user", user.id),
	})

	return message(form, "Report sent successfully.")
}
