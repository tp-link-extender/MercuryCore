import { authoriseMod, authorise } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import { prisma } from "$lib/server/prisma"
import type { ModerationActionType } from "@prisma/client"

// Make sure a user is an administrator/moderator before loading the page.
export async function load({ locals }) {
	await authoriseMod(locals)
}

export const actions = {
	moderateUser: async ({ request, locals, getClientAddress }) => {
		await authoriseMod(locals)

		const { user } = await authorise(locals.validateUser)

		const limit = ratelimit("moderateUser", getClientAddress, 30)
		if (limit) return limit

		const data = await formData(request)
		const username = data.username
		const action = parseInt(data.action)
		const banDate = new Date(data.banDate)
		const reason = data.reason

		if (!username || !action) return fail(400, { msg: "Missing fields" })
		if (action != 5 && !reason) return fail(400, { msg: "Missing fields" })
		if (action == 2 && !banDate) return fail(400, { msg: "Missing fields" })
		if (reason.length < 15 && reason.length > 150)
			return fail(400, { msg: "Reason is too long/short" })

		if (action == 2 && banDate.getTime() < new Date().getTime())
			return fail(400, { msg: "Invalid date" })

		const getModeratee = await prisma.user.findUnique({
			where: {
				username,
			},
		})

		if (!getModeratee) return fail(400, { msg: "User does not exist" })

		if (getModeratee.permissionLevel > 2)
			return fail(400, {
				msg: "You cannot moderate staff members",
			})
		if (getModeratee.id == user.userId)
			return fail(400, {
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
