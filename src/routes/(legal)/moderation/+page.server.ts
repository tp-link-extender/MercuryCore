import surql from "$lib/surrealtag"
import { query, squery } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import { error, redirect } from "@sveltejs/kit"

// Make sure a user has been moderated before loading the page.
export async function load({ locals }) {
	const { user } = await authorise(locals),
		userModeration = await squery<{
			type: string
			note: string
			time: string
			timeEnds: string
		}>(
			surql`
				SELECT *
				FROM moderation
				WHERE out = $user
					AND active = true`,
			{ user: `user:${user.id}` },
		)

	if (!userModeration)
		throw error(
			454,
			"Your ID has been sent to the Mercury Servers for moderation. Thank you!",
		)

	return userModeration
}

export const actions = {
	default: async ({ locals }) => {
		const { user } = await authorise(locals),
			userModeration = await squery<{
				type: string
				timeEnds: string
			}>(
				surql`
					SELECT *
					FROM moderation
					WHERE out = $user
						AND active = true`,
				{ user: `user:${user.id}` },
			)

		if (!userModeration)
			throw error(
				454,
				"Your ID has been sent to the Mercury Servers for moderation. Thank you!",
			)

		if (new Date(userModeration.timeEnds).getTime() > Date.now())
			throw error(400, "Your moderation action has not yet ended")

		if (
			userModeration.type == "AccountDeleted" ||
			userModeration.type == "Termination"
		)
			throw error(400, "You cannot reactivate your account")

		await query(
			surql`
				UPDATE moderation SET active = false
				WHERE out = $user`,
			{ user: `user:${user.id}` },
		)

		throw redirect(302, "/home")
	},
}
