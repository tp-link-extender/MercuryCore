import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { RecordId, equery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	category: z.enum([
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
		"Under13",
	]),
	note: z.string().optional(),
})

// const getReportee = (username: string) =>
async function getReportee(username: string) {
	const [[reportee]] = await equery<{ id: RecordId }[][]>(
		surql`SELECT id FROM user WHERE username = ${username}`
	)

	return reportee
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
		form: await superValidate(zod(schema)),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, url, getClientAddress }) => {
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)
	const limit = ratelimit(form, "report", getClientAddress, 120)
	if (limit) return limit

	const { user } = await authorise(locals)
	const { category, note } = form.data
	const username = url.searchParams.get("user")
	const reportUrl = url.searchParams.get("url")
	if (!username || !reportUrl) error(400, "Missing fields")

	const reportee = await getReportee(username)
	if (!reportee) return message(form, "Invalid user", { status: 400 })

	await equery(
		surql`
			RELATE ${new RecordId("user", user.id)}->report->${reportee.id} CONTENT {
				time: time::now(),
				note: ${note},
				url: ${reportUrl},
				category: ${category},
			}`
	)

	return message(form, "Report sent successfully.")
}
