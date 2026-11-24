import { redirect } from "@sveltejs/kit"
import { authorise, cookieName } from "#lib/server/auth.ts"
import { invalidateSession } from "#lib/server/db/sessions.ts"
import { command, form, getRequestEvent } from "$app/server"

export const logoutForm = form(async () => {
	const { cookies, locals } = getRequestEvent()
	// Moderated users must still be able to log out.
	const { session } = await authorise(locals, undefined, true)

	await invalidateSession(session)
	cookies.delete(cookieName, { path: "/" })

	redirect(302, "/login")
})

// hooks.server.ts updates the user's status when pinged
export const statusPing = command(async () => {})
