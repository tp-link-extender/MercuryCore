import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import { fail, error } from "@sveltejs/kit"
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

export async function load(event) {
	const reportee = event.url.searchParams.get("user")
	const reportedUrl = event.url.searchParams.get("url")

	if (!reportee || !reportedUrl)
		throw error(400, "Missing user or url parameters")

	return {
		reportee,
		url: reportedUrl,
		form: superValidate(event, schema),
	}
}

export const actions = {
	default: async event => {
		ratelimit("report", event.getClientAddress, 120)
		const { user } = await authorise(event.locals)

		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const { category, note } = form.data

		const reportee = await prisma.authUser.findUnique({
			where: {
				username: event.url.searchParams.get("user"),
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
				url: event.url.searchParams.get("url"),
				category,
			},
		})

		return message(form, "Report sent successfully.")
	},
}
