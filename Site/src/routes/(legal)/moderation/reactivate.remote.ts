import { error, redirect } from "@sveltejs/kit"
import { form, getRequestEvent } from "$app/server"
import { authorise } from "#lib/server/auth.ts"
import { db, Record } from "#lib/server/surreal.ts"
import getModerationQuery from "./getModeration.surql"
import unmoderateQuery from "./unmoderate.surql"

interface Moderation {
	note: string
	time: string
	timeEnds: string
	type: string
}

async function getModeration(id: string) {
	const [[moderation]] = await db.query<Moderation[][]>(getModerationQuery, {
		user: Record("user", id),
	})
	if (!moderation) redirect(302, "/home")

	return moderation
}

export const reactivateForm = form(async () => {
	const { locals } = getRequestEvent()
	const { user } = await authorise(locals)
	const userModeration = await getModeration(user.id)
	if (new Date(userModeration.timeEnds).getTime() > Date.now())
		error(400, "Your moderation action has not yet ended")
	if (userModeration.type === "Termination")
		error(400, "You cannot reactivate your account")

	await db.query(unmoderateQuery, { user: Record("user", user.id) })

	redirect(302, "/home")
})
