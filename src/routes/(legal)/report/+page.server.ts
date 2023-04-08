import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import { error } from "@sveltejs/kit"
import type { ReportCategory } from "@prisma/client"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
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

export async function load({ url }) {
	const reportee = url.searchParams.get("user")
	const reportedUrl = url.searchParams.get("url")

	if (!reportee || !reportedUrl)
		throw error(400, "Missing user or url parameters")

	return {
		reportee,
		url: reportedUrl,
		form: superValidate(schema),
	}
}

export const actions = {
	default: async ({ request, locals, url, getClientAddress }) => {
		ratelimit("report", getClientAddress, 120)
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { category, note } = form.data
		const username = url.searchParams.get("user")
		const userUrl = url.searchParams.get("user")

		if (!username || !userUrl) throw error(400, "Missing fields")

		const reportee = await prisma.authUser.findUnique({
			where: {
				username,
			},
		})
		if (!reportee)
			return message(form, "Invalid user", {
				status: 400,
			})

		await prisma.report.create({
			data: {
				reporterId: user.id,
				reporteeId: reportee.id,
				note: (note as ReportCategory) || null,
				url: userUrl,
				category,
			},
		})

		return message(form, "Report sent successfully.")
	},
}
