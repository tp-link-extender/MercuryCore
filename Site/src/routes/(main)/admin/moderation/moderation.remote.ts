import { type } from "arktype"
import { authorise } from "#lib/server/auth.ts"
import { sendModerationDiscordWebhook } from "#lib/server/discordModerationWebhook.ts"
import { ratelimitRemote } from "#lib/server/ratelimit.ts"
import { db, findWhere, Record } from "#lib/server/surreal.ts"
import type { ClientForm } from "#lib/validate.ts"
import { form, getRequestEvent } from "$app/server"
import moderateQuery from "./moderate.surql"
import moderateeQuery from "./moderatee.surql"
import moderationOptions from "./moderationOptions"
import unbanQuery from "./unban.surql"

const schema = type({
	// enum to allow 1 to be selected initially
	action: type.enumerated(...moderationOptions).configure({
		problem: "must be a valid moderation action",
	}),
	"banDate?": type("string | undefined").pipe.try(date => {
		if (!date) return undefined
		const d = new Date(date)
		if (Number.isNaN(d.getTime())) throw new TypeError("Invalid date")
		return d
	}),
	reason: "15 <= string <= 150",
	username: "3 <= string <= 21",
})

export const formData: ClientForm<typeof schema.inferIn> = form(
	schema,
	async ({ username, action, banDate, reason }, issues) => {
		const { locals, getClientAddress } = getRequestEvent()
		const { user } = await authorise(locals, 4)

		if (action === "Ban" && (banDate?.getTime() || 0) < Date.now())
			return issues.banDate("Invalid date")

		interface Moderatee {
			id: string
			permissionLevel: number
		}
		const [[getModeratee]] = await db.query<Moderatee[][]>(moderateeQuery, {
			username,
		})
		if (!getModeratee) return issues.username("User does not exist")
		if (getModeratee.permissionLevel > 2)
			return issues.username("You cannot moderate staff members")
		if (getModeratee.id === user.id)
			return issues.username("You cannot moderate yourself")

		const limit = ratelimitRemote(
			issues,
			"moderateUser",
			getClientAddress,
			30
		)
		if (limit) return limit

		const qParams = Object.freeze({
			moderatee: Record("user", getModeratee.id),
			user: Record("user", user.id),
		})

		const moderated = await findWhere(
			"moderation",
			"out = $moderatee AND active = true",
			qParams
		)

		if (action === "Unban") {
			if (!moderated)
				return issues.action(
					"You cannot unban a user that has not been moderated yet"
				)

			await db.query(unbanQuery, {
				...qParams,
				note: `Unban ${username}`,
			})

			return { success: `${username} has been unbanned` }
		}

		if (moderated) return issues.username("User has already been moderated")

		const actionLabels: { [_: string]: () => [string, string] } = {
			Ban: () => [
				`Ban ${username}`,
				`banned until ${banDate?.toLocaleDateString()}`,
			],
			Termination: () => [`Terminate ${username}`, "terminated"],
			Warning: () => [`Warn ${username}`, "warned"],
		}

		const [note, actioned] = actionLabels[action]()

		await db.query(moderateQuery, {
			...qParams,
			moderationAction: action,
			note: `${note}: ${reason}`,
			reason,
			timeEnds: banDate || new Date(),
		})

		await sendModerationDiscordWebhook({
			action,
			moderatorUsername: user.username,
			reason,
			username,
		})

		return { success: `${username} has been ${actioned}` }
	}
)
