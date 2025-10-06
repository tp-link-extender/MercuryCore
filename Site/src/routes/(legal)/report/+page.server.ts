import { error } from "@sveltejs/kit"
import { type } from "arktype"
import { arktype } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { db, Record, type RecordId } from "$lib/server/surreal"
import getReporteeQuery from "./getReportee.surql"
import reportQuery from "./report.surql"

const schema = type({
	category: type
		.enumerated(
			"AccountTheft",
			"Dating",
			"Exploiting",
			"Harassment",
			"InappropriateContent",
			"PersonalInformation",
			"Scamming",
			"Spam",
			"Swearing",
			"Threats",
			"Under13"
		)
		.describe("a valid report category"),
	note: "string | undefined",
})

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
		form: await superValidate(arktype(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, url, getClientAddress }) => {
	const { user } = await authorise(locals)
	const form = await superValidate(request, arktype(schema))
	if (!form.valid) return formError(form)

	const { category, note } = form.data
	const username = url.searchParams.get("user")
	const reportUrl = url.searchParams.get("url")
	if (!username || !reportUrl) error(400, "Missing fields")

	const reportee = await getReportee(username)
	if (!reportee) return message(form, "Invalid user")

	const limit = ratelimit(form, "report", getClientAddress, 120)
	if (limit) return limit

	await db.query(reportQuery, {
		user: Record("user", user.id),
		reportee,
		note,
		reportUrl,
		category,
	})

	return message(form, "Report sent successfully.")
}
