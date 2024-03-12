import { authorise } from "$lib/server/lucia"
import { query, squery, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import { error } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
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

const getReportee = (username: string) =>
	squery<{ id: string }>(
		surql`
			SELECT id
			FROM user
			WHERE username = $username`,
		{ username }
	)

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

export const actions = {
	default: async ({ request, locals, url, getClientAddress }) => {
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

		if (!reportee)
			return message(form, "Invalid user", {
				status: 400,
			})

		await query(
			surql`
				RELATE $reporter->report->$reportee CONTENT {
					time: time::now(),
					note: $note,
					url: $reportUrl,
					category: $category,
				}`,
			{
				reporter: `user:${user.id}`,
				reportee: reportee.id,
				note,
				reportUrl,
				category,
			}
		)

		return message(form, "Report sent successfully.")
	},
}
