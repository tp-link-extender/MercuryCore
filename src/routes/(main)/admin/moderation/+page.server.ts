import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { findWhere, equery, RecordId, surrealql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { zod } from "sveltekit-superforms/adapters"
import { z } from "zod"
import auditLogQuery from "$lib/server/auditLog.surql"

const schema = z.object({
	username: z.string().min(3).max(21),
	// enum to allow 1 to be selected initially
	action: z.enum(["1", "2", "3", "4", "5"]),
	banDate: z.string().optional(),
	reason: z.string().min(15).max(150),
})

export async function load({ locals }) {
	await authorise(locals, 4)

	return { form: await superValidate(zod(schema)) }
}

const moderationActions = ["Warning", "Ban", "Termination", "AccountDeleted"]

export const actions: import("./$types").Actions = {}
actions.default = async ({ request, locals, getClientAddress }) => {
	const { user } = await authorise(locals, 4)
	const form = await superValidate(request, zod(schema))
	if (!form.valid) return formError(form)

	const { username, action, banDate, reason } = form.data
	const date = banDate ? new Date(banDate) : null
	const intAction = +action

	if (intAction === 2 && (date?.getTime() || 0) < new Date().getTime())
		return formError(form, ["banDate"], ["Invalid date"])

	const [[getModeratee]] = await equery<
		{
			id: string
			number: number
			permissionLevel: number
		}[][]
	>(
		surrealql`
			SELECT meta::id(id) AS id, number, permissionLevel
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

	const moderationMessage = [
		() => "warned",
		() => `banned until ${date?.toLocaleDateString()}`,
		() => "terminated",
		() => "deleted",
	]
	const qParams = {
		user: new RecordId("user", user.id),
		moderatee: new RecordId("user", getModeratee.id),
		action: "Moderation",
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
			`
				UPDATE moderation SET active = false WHERE out = $moderatee;
				${auditLogQuery}`,
			{ ...qParams, note: `Unban ${username}` }
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

	const notes = [
		() => `Warn ${username}`,
		() => `Ban ${username}`,
		() => `Terminate ${username}`,
		() => `Delete ${username}'s account`,
	]

	await equery(
		`
			RELATE $moderator->moderation->$moderatee CONTENT {
				note: $reason,
				type: $moderationAction,
				time: time::now(),
				timeEnds: $timeEnds,
				active: true,
			};
			${auditLogQuery}`,
		{
			note: `${notes[intAction - 1]()}: ${reason}`,
			reason,
			moderationAction: moderationActions[intAction - 1],
			timeEnds: date || new Date(),
			...qParams,
		}
	)

	return message(
		form,
		`${username} has been ${moderationMessage[intAction - 1]()}`
	)
}
