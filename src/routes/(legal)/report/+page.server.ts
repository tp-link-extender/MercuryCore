import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import ratelimit from "$lib/server/ratelimit"
import { fail, error } from "@sveltejs/kit"
import type { ReportCategory } from "@prisma/client"

export async function load({ url, locals }) {
	const reportedUser = url.searchParams.get("user")
	const reportedUrl = url.searchParams.get("url")

	if (!reportedUser || !reportedUrl) throw error(400, "Missing user or url parameters")

	return {
		user: reportedUser,
		url: reportedUrl,
	}
}

export const actions = {
	default: async ({ request, locals, url, getClientAddress }) => {
		// ratelimit("report", getClientAddress, 120)
		const { user } = await authoriseUser(locals.validateUser)
		const data = await request.formData()
		const reportUser = url.searchParams.get("user")
		const reportUrl = url.searchParams.get("url")
		const category = (data.get("category") as string).trim()
		const note = (data.get("note") as string).trim() || null

		if (!reportUser || !reportUrl || !category) return fail(400, { msg: "Missing fields" })
		if (!["AccountTheft", "Dating", "Exploiting", "Harassment", "InappropriateContent", "PersonalInformation", "Scamming", "Spam", "Swearing", "Threats", "Under13"].includes(category))
			return fail(400, { msg: "Invalid category" })

		const reportee = await prisma.user.findUnique({
			where: {
				username: reportUser,
			},
			select: { id: true },
		})
		if (!reportee) return fail(400, { msg: "Invalid user" })

		await prisma.report.create({
			data: {
				reporterId: user.userId,
				reporteeId: reportee.id,
				note,
				url: reportUrl,
				category: category as ReportCategory,
			},
		})

		return {
			success: true,
			msg: "Report sent successfully.",
		}
	},
}
