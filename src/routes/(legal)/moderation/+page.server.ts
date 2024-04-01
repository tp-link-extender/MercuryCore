import { query, squery, surql } from "$lib/server/surreal"
import { authorise } from "$lib/server/lucia"
import { error, redirect } from "@sveltejs/kit"

const getModeration = async (id: string) => {
	const moderation = await squery<{
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
		{ user: `user:${id}` }
	)

	if (moderation) return moderation

	error(
		454,
		"Your ID has been sent to the Graphictoria Servers for moderation. Thank you!"
	)
}

// Make sure a user has been moderated before loading the page.
export async function load({ locals }) {
	const { user } = await authorise(locals)

	return await getModeration(user.id)
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals }) => {
	const { user } = await authorise(locals)
	const userModeration = await getModeration(user.id)

	if (new Date(userModeration.timeEnds).getTime() > Date.now())
		error(400, "Your moderation action has not yet ended")

	if (["AccountDeleted", "Termination"].includes(userModeration.type))
		error(400, "You cannot reactivate your account")

	await query(
		surql`
			UPDATE moderation SET active = false
			WHERE out = $user`,
		{ user: `user:${user.id}` }
	)

	redirect(302, "/home")
}
