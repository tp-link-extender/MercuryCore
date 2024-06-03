import { authorise } from "$lib/server/lucia"
import { RecordId, equery, surrealql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

async function getModeration(id: string) {
	const [[moderation]] = await equery<
		{
			type: string
			note: string
			time: string
			timeEnds: string
		}[][]
	>(
		surrealql`
			SELECT * FROM moderation
			WHERE out = ${new RecordId("user", id)} AND active = true`
	)

	if (moderation) return moderation

	error(
		454,
		"Your ID has been sent to the Mercury Servers for moderation. Thank you!"
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

	await equery(
		surrealql`
			UPDATE moderation SET active = false
			WHERE out = ${new RecordId("user", user.id)}`
	)

	redirect(302, "/home")
}
