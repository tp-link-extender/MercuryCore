import { authorise } from "$lib/server/lucia"
import { Record, db } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"
import getModerationQuery from "./getModeration.surql"
import unmoderateQuery from "./unmoderate.surql"

type Moderation = {
	type: string
	note: string
	time: string
	timeEnds: string
}

async function getModeration(id: string) {
	const [[moderation]] = await db.query<Moderation[][]>(getModerationQuery, {
		user: Record("user", id),
	})
	if (!moderation) redirect(302, "/home")

	return moderation
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
	if (userModeration.type === "Termination")
		error(400, "You cannot reactivate your account")

	await db.query(unmoderateQuery, { user: Record("user", user.id) })

	redirect(302, "/home")
}
