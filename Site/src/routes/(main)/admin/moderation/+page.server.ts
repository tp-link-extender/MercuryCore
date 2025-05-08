import { authorise } from "$lib/server/auth"
import formError from "$lib/server/formError"
import ratelimit from "$lib/server/ratelimit"
import { Record, db, findWhere } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"
import assocreportQuery from "./assocreport.surql"
import moderateQuery from "./moderate.surql"
import moderateeQuery from "./moderatee.surql"
import unbanQuery from "./unban.surql"

const schema = z.object({
	username: z.string().min(3).max(21),
	// enum to allow 1 to be selected initially
	action: z.enum(["1", "2", "3", "4"], {
		message: "Select a moderation action",
	}),
	banDate: z.string().optional(),
	reason: z.string().min(15).max(150),
})

export async function load({ locals, url }) {
	await authorise(locals, 4)

	const associatedReport = url.searchParams.get("report")
	if (!associatedReport) return { form: await superValidate(zod(schema)) }

	const [report] = await db.query<
		({ note: string; reportee: string } | undefined)[]
	>(assocreportQuery, {
		report: Record("report", associatedReport),
	})
	if (!report) error(400, "Invalid report id")

	return {
		form: await superValidate(
			{
				username: report.reportee,
				reason: report.note,
			},
			zod(schema)
		),
		report,
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals, request, getClientAddress }) => {
	const { user } = await authorise(locals, 4)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { username, action, banDate, reason } = form.data
	const date = banDate ? new Date(banDate) : null
	const intAction = +action
	if (intAction === 2 && (date?.getTime() || 0) < Date.now())
		return formError(form, ["banDate"], ["Invalid date"])

	type Moderatee = {
		id: string
		permissionLevel: number
	}
	const [[getModeratee]] = await db.query<Moderatee[][]>(moderateeQuery, {
		username,
	})
	if (!getModeratee)
		return formError(form, ["username"], ["User does not exist"])
	if (getModeratee.permissionLevel > 2)
		return formError(
			form,
			["username"],
			["You cannot moderate staff members"]
		)
	if (getModeratee.id === user.id)
		return formError(form, ["username"], ["You cannot moderate yourself"])

	const limit = ratelimit(form, "moderateUser", getClientAddress, 30)
	if (limit) return limit

	const qParams = {
		user: Record("user", user.id),
		moderatee: Record("user", getModeratee.id),
	}

	if (intAction === 4) {
		// Unban
		const foundUnban = await findWhere(
			"moderation",
			`in = $user
				AND out = $moderatee
				AND active = true`,
			qParams
		)
		if (!foundUnban)
			return formError(
				form,
				["action"],
				["You cannot unban a user that has not been moderated yet"]
			)

		await db.query(unbanQuery, {
			...qParams,
			note: `Unban ${username}`,
		})

		return message(form, `${username} has been unbanned`)
	}

	const foundModeration = await findWhere(
		"moderation",
		"out = $moderatee AND active = true",
		qParams
	)
	if (foundModeration)
		return formError(
			form,
			["username"],
			["User has already been moderated"]
		)

	const [moderationAction, note, actioned] = [
		() => ["Warning", `Warn ${username}`, "warned"],
		() => [
			"Ban",
			`Ban ${username}`,
			`banned until ${date?.toLocaleDateString()}`,
		],
		() => ["Termination", `Terminate ${username}`, "terminated"],
	][intAction - 1]()

	await db.query(moderateQuery, {
		...qParams,
		reason,
		moderationAction,
		timeEnds: date || new Date(),
		note: `${note}: ${reason}`,
	})

	return message(form, `${username} has been ${actioned}`)
}
