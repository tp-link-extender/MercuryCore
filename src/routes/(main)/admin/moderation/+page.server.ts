import { authoriseMod, authoriseUser } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import { prisma } from "$lib/server/prisma"
import type { ModerationActionType } from "@prisma/client"

// Make sure a user is an administrator/moderator before loading the page.
export async function load({ locals }) {
	await authoriseMod(locals)
}

export const actions = {
	moderateUser: async ({ request, locals, getClientAddress }) => {
		await authoriseMod(locals)

		const { user } = await authoriseUser(locals.validateUser)

		const limit = ratelimit("moderateUser", getClientAddress, 30)
		if (limit) return limit

		const data = await request.formData()
		const username = (data.get("username") as string).trim()
		const action = parseInt(data.get("action") as string)
		const banDate = new Date(data.get("banDate") as string)
		const reason = (data.get("reason") as string).trim()

		if (!username || !action)
			return fail(400, { error: true, msg: "Missing fields" })
		if (action != 5 && !reason)
			return fail(400, { error: true, msg: "Missing fields" })
		if (action == 2 && !banDate) return fail(400, { msg: "Missing fields" })
		if (reason.length < 15 && reason.length > 150)
			return fail(400, { error: true, msg: "Reason is too long/short" })

		if (action == 2 && banDate.getTime() < new Date().getTime())
			return fail(400, { error: true, msg: "Invalid date" })

		const getModeratee = await prisma.user.findUnique({
			where: {
				username,
			},
		})

		if (!getModeratee)
			return fail(400, { error: true, msg: "User does not exist" })

		if (getModeratee.permissionLevel > 2)
			return fail(400, {
				error: true,
				msg: "You cannot moderate staff members",
			})
		if (getModeratee.id == user.userId)
			return fail(400, {
				error: true,
				msg: "You cannot moderate yourself",
			})

		const moderationMessage = [
			"has been warned",
			`has been banned until ${banDate.toLocaleDateString()}`,
			"has been terminated",
			"has been deleted",
			"has been unbanned",
		]

		const moderationActions = [
			"Warning",
			"Ban",
			"Termination",
			"AccountDeleted",
		]

		if (action == 5) {
			// Unban
			if (
				!(await prisma.moderationAction.count({
					where: { moderateeId: getModeratee.id, active: true },
				}))
			)
				return fail(400, {
					error: true,
					msg: "You cannot unban a user that has not been moderated yet",
				})

			if (
				await prisma.moderationAction.count({
					where: {
						moderateeId: getModeratee.id,
						active: true,
						type: "AccountDeleted",
					},
				})
			)
				return fail(400, {
					error: true,
					msg: "You cannot undo a deleted user",
				})

			await prisma.moderationAction.updateMany({
				where: {
					moderateeId: getModeratee.id,
				},
				data: {
					active: false,
				},
			})

			return {
				moderationsuccess: true,
				msg: `${username} ${moderationMessage[action - 1]}`,
			}
		}

		const moderationAction = moderationActions[action - 1]

		if (
			await prisma.moderationAction.count({
				where: { moderateeId: getModeratee.id, active: true },
			})
		)
			return fail(400, {
				error: true,
				msg: "User has already been moderated",
			})

		if (action == 4) {
			// Delete Account
			await prisma.user.update({
				where: {
					username,
				},
				data: {
					username: `[ Deleted User ${getModeratee.number} ]`,
				},
			})
		}

		await prisma.moderationAction.create({
			data: {
				moderator: {
					connect: {
						id: user.userId,
					},
				},
				moderatee: {
					connect: {
						username,
					},
				},
				timeEnds: action == 2 ? banDate : new Date(),
				note: reason,
				type: moderationAction as ModerationActionType,
			},
		})

		return {
			moderationsuccess: true,
			msg: `${username} ${moderationMessage[action - 1]}`,
		}
	},
}
