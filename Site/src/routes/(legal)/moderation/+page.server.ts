import config from "$lib/server/config"
import { authorise } from "$lib/server/lucia"
import { Record, equery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

type Moderation = {
	type: string
	note: string
	time: string
	timeEnds: string
}

async function getModeration(id: string) {
	const [[moderation]] = await equery<Moderation[][]>(
		surql`
			SELECT * FROM moderation
			WHERE out = ${Record("user", id)} AND active = true`
	)
	if (moderation) return moderation

	error(
		454,
		`Your ID has been sent to the ${config.Name} Servers for moderation. Thank you!`
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
		surql`
			UPDATE moderation SET active = false
			WHERE out = ${Record("user", user.id)}`
	)

	redirect(302, "/home")
}
