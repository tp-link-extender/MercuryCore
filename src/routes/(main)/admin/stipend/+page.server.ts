import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { client } from "$lib/server/redis"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	dailyStipend: z.number().int().positive().max(100),
	stipendTime: z.number().min(1),
})

export async function load({ locals }) {
	// Make sure a user is an administrator before loading the page.
	await authorise(locals, 5)

	return {
		form: superValidate(schema),
		dailyStipend: Number((await client.get("dailyStipend")) || 10),
		stipendTime: Number((await client.get("stipendTime")) || 12),
	}
}

export const actions = {
	updateStipend: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals, 5)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)
		const limit = ratelimit(form, "resetPassword", getClientAddress, 30)
		if (limit) return limit

		const currentStipend = Number((await client.get("dailyStipend")) || 10)
		const currentStipendTime = Number(
			(await client.get("stipendTime")) || 12,
		)

		const { dailyStipend, stipendTime } = form.data

		if (currentStipend == dailyStipend && currentStipendTime == stipendTime)
			return message(form, "No changes were made")

		await Promise.all([
			client.set("dailyStipend", dailyStipend),
			client.set("stipendTime", stipendTime),
		])

		let auditText = ""

		if (currentStipend != dailyStipend)
			auditText += `Change daily stipend from ${currentStipend} to ${dailyStipend}`

		if (currentStipendTime != stipendTime) {
			if (auditText) auditText += ", "
			auditText += `Change stipend time from ${currentStipendTime} to ${stipendTime}`
		}

		await prisma.auditLog.create({
			data: {
				action: "Account",
				note: auditText,
				user: {
					connect: {
						id: user.id,
					},
				},
			},
		})

		return message(form, "Economy updated successfully!")
	},
}
