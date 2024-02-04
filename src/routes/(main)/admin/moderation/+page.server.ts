import { authorise } from "$lib/server/lucia"
import ratelimit from "$lib/server/ratelimit"
import { query, squery, surql } from "$lib/server/surreal"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	username: z.string().min(3).max(21),
	// enum to allow 1 to be selected initially
	action: z.enum(["1", "2", "3", "4", "5"]),
	banDate: z.string().optional(),
	reason: z.string().min(15).max(150),
})

export async function load({ locals }) {
	// Make sure a user is an administrator/moderator before loading the page.
	await authorise(locals, 4)

	return {
		form: await superValidate(schema),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const { user } = await authorise(locals, 4)
		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { username, action, banDate, reason } = form.data
		const date = banDate ? new Date(banDate) : null
		const intAction = parseInt(action)

		if (intAction === 2 && (date?.getTime() || 0) < new Date().getTime())
			return formError(form, ["banDate"], ["Invalid date"])

		const getModeratee = await squery<{
			id: string
			number: number
			permissionLevel: number
		}>(
			surql`
				SELECT
					meta::id(id) AS id,
					number,
					permissionLevel
				FROM user
				WHERE username = $username`,
			{ username }
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
			return formError(
				form,
				["username"],
				["You cannot moderate yourself"]
			)

		const limit = ratelimit(form, "moderateUser", getClientAddress, 30)
		if (limit) return limit

		const moderationMessage = [
			"warned",
			`banned until ${date?.toLocaleDateString()}`,
			"terminated",
			"deleted",
		]
		const moderationActions = [
			"Warning",
			"Ban",
			"Termination",
			"AccountDeleted",
		]
		const qParams = {
			moderator: `user:${user.id}`,
			moderatee: `user:${getModeratee.id}`,
		}

		if (intAction === 5) {
			// Unban
			if (
				!(await squery(
					surql`
						SELECT * FROM moderation
						WHERE in = $moderator
							AND out = $moderatee
							AND active = true`,
					qParams
				))
			)
				return formError(
					form,
					["action"],
					["You cannot unban a user that has not been moderated yet"]
				)

			if (
				await squery(
					surql`
						SELECT * FROM moderation
						WHERE in = $moderator
							AND out = $moderatee
							AND active = true
							AND type = "AccountDeleted"`,
					qParams
				)
			)
				return formError(
					form,
					["action"],
					["You cannot unban a deleted user"]
				)

			await query(
				surql`
					UPDATE moderation SET active = false
					WHERE out = $moderatee;
					CREATE auditLog CONTENT {
						action: "Moderation",
						note: $note,
						user: $moderator,
						time: time::now(),
					}`,
				{
					note: `Unban ${username}`,
					...qParams,
				}
			)

			return message(form, `${username} has been unbanned`)
		}

		const moderationAction = moderationActions[intAction - 1]

		if (
			await squery(
				surql`
					SELECT * FROM moderation
					WHERE out = $moderatee
						AND active = true`,
				qParams
			)
		)
			return formError(
				form,
				["username"],
				["User has already been moderated"]
			)

		await query(
			surql`
				RELATE $moderator->moderation->$moderatee CONTENT {
					note: $reason,
					type: $moderationAction,
					time: time::now(),
					timeEnds: $timeEnds,
					active: true,
				};
				CREATE auditLog CONTENT {
					action: "Moderation",
					note: $note,
					user: $moderator,
					time: time::now(),
				}`,
			{
				note: `${
					[
						`Warn ${username}`,
						`Ban ${username}`,
						`Terminate ${username}`,
						`Delete ${username}'s account`,
					][intAction - 1]
				}: ${reason}`,
				reason,
				moderationAction,
				timeEnds: date || new Date(),
				...qParams,
			}
		)

		return message(
			form,
			`${username} has been ${moderationMessage[intAction - 1]}`
		)
	},
}
