import { authorise } from "$lib/server/lucia"
import surreal, { query, surql } from "$lib/server/surreal"
import ratelimit from "$lib/server/ratelimit"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"

const schema = z.object({
	dailyStipend: z.number().int().positive().max(100),
	stipendTime: z.number().min(1),
})

export async function load({ locals }) {
	await authorise(locals, 5)

	const economy = (await surreal.select("stuff:economy"))[0]

	return {
		form: await superValidate(zod(schema)),
		dailyStipend: (economy?.dailyStipend as number) || 10,
		stipendTime: (economy?.stipendTime as number) || 10,
	}
}

export const actions = {
	updateStipend: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals, 5)
		const form = await superValidate(request, zod(schema))
		if (!form.valid) return formError(form)

		const limit = ratelimit(form, "economy", getClientAddress, 30)
		if (limit) return limit

		const economy = (await surreal.select("stuff:economy"))[0]
		const currentStipend = economy?.dailyStipend || 10
		const currentStipendTime = economy?.stipendTime || 12
		const { dailyStipend, stipendTime } = form.data

		if (
			currentStipend === dailyStipend &&
			currentStipendTime === stipendTime
		)
			return message(form, "No changes were made")

		await surreal.merge("stuff:economy", {
			dailyStipend,
			stipendTime,
		})

		let auditText = ""

		if (currentStipend !== dailyStipend)
			auditText += `Change daily stipend from ${currentStipend} to ${dailyStipend}`

		if (currentStipendTime !== stipendTime) {
			if (auditText) auditText += ", "
			auditText += `Change stipend time from ${currentStipendTime} to ${stipendTime}`
		}

		await query(
			surql`
				CREATE auditLog CONTENT {
					action: "Account",
					note: $note,
					user: $user,
					time: time::now()
				}`,
			{
				note: auditText,
				user: `user:${user.id}`,
			}
		)

		return message(form, "Economy updated successfully!")
	},
}
