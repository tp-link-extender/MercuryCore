import { error, redirect } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import { activeModerationOf, unmoderate } from "#lib/server/db/moderation.ts"
import { form, getRequestEvent } from "$app/server"

async function getModeration(id: string) {
	const moderation = await activeModerationOf(id)
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

	await unmoderate(user.id)

	redirect(302, "/home")
})
