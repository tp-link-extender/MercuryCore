import { authorise } from "$lib/server/lucia"
import { fail, error, redirect } from "@sveltejs/kit"
import { prisma } from "$lib/server/prisma"

// Make sure a user has been moderated before loading the page.
export async function load({ locals }) {
	const { user } = await authorise(locals)

	const userModeration = await prisma.moderationAction.findMany({
		where: {
			moderateeId: user.id,
			active: true,
		},
	})

	if (!userModeration[0])
		throw error(
			404,
			"Your ID has been sent to the Mercury Servers for moderation. Thank you!"
		)

	return userModeration[0]
}

export const actions = {
	default: async ({ locals }) => {
		const { user } = await authorise(locals)

		const userModeration = await prisma.moderationAction.findMany({
			where: {
				moderateeId: user.id,
				active: true,
			},
		})

		if (!userModeration[0])
			throw error(
				404,
				"Your ID has been sent to the Mercury Servers for moderation. Thank you!"
			)

		if (userModeration[0].timeEnds.getTime() > Date.now()) throw fail(400)

		if (
			userModeration[0].type == "AccountDeleted" ||
			userModeration[0].type == "Termination"
		)
			throw fail(400)

		await prisma.moderationAction.updateMany({
			where: {
				moderateeId: user.id,
				active: true,
			},
			data: {
				active: false,
			},
		})

		throw redirect(302, "/home")
	},
}
