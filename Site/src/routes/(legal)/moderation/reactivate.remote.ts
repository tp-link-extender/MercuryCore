import { error, redirect } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import { form, getRequestEvent } from "$app/server"
import getModerationQuery from "./getModeration.surql"
import unmoderateQuery from "./unmoderate.surql"

interface Moderation {
	note: string
	time: string
	timeEnds: string
	type: string
}

async function getModeration(id: string) {
	const [[moderation]] = await dbQuery<Moderation[][]>(getModerationQuery, {
		user: Record("user", id),
	})
	if (!moderation) redirect(302, "/home")

	return moderation
}

export const reactivateForm = form(async () => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals, undefined, true)
	const userModeration = await getModeration(user.id)
	if (new Date(userModeration.timeEnds).getTime() > Date.now())
		error(400, "Your moderation action has not yet ended")
	if (userModeration.type === "Termination")
		error(400, "You cannot reactivate your account")

	await dbQuery(unmoderateQuery, { user: Record("user", user.id) })

	redirect(302, "/home")
})
