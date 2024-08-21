import formError from "$lib/server/formError"
import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { Record, equery, findWhere, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import { zod } from "sveltekit-superforms/adapters"
import { message, superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z.string().min(3).max(21),
	// enum to allow 1 to be selected initially
	action: z.enum(["1", "2", "3", "4", "5"]),
	banDate: z.string().optional(),
	reason: z.string().min(15).max(150),
})

export async function load({ locals, url }) {
	await authorise(locals, 4)

	const form = await superValidate(zod(schema))

	const associatedReport = url.searchParams.get("report")
	if (associatedReport) {
		const [[report]] = await equery<{ username: string }[][]>(
			surql`SELECT * FROM ${Record("report", associatedReport)}`
		)
		if (!report) error(400, "Invalid report id")
		return { form }
	}

	return { form }
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
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
	const [[getModeratee]] = await equery<Moderatee[][]>(
		surql`
			SELECT meta::id(id) AS id, permissionLevel
			FROM user WHERE username = ${username}`
	)
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

	if (intAction === 5) {
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

		const foundDeleted = await findWhere(
			"moderation",
			`in = $user
				AND out = $moderatee
				AND active = true
				AND type = "AccountDeleted"`,
			qParams
		)

		if (foundDeleted)
			return formError(
				form,
				["action"],
				["You cannot unban a deleted user"]
			)

		await equery(
			surql`
				UPDATE moderation SET active = false WHERE out = $moderatee;
				fn::auditLog("Moderation", ${`Unban ${username}`}, $user)`,
			qParams
		)

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
		() => ["AccountDeletion", `Delete ${username}'s account`, "deleted"],
	][intAction - 1]()

	await equery(
		surql`
			RELATE $moderator->moderation->$moderatee CONTENT {
				note: $reason,
				type: $moderationAction,
				time: time::now(),
				timeEnds: $timeEnds,
				active: true,
			};
			fn::auditLog("Moderation", ${`${note}: ${reason}`}, $user)`,
		{
			reason,
			moderationAction,
			timeEnds: date || new Date(),
			...qParams,
		}
	)

	return message(form, `${username} has been ${actioned}`)
}
