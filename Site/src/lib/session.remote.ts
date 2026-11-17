import { redirect } from "@sveltejs/kit"
import { command, form, getRequestEvent } from "$app/server"
import { authorise, cookieName, invalidateSession } from "#lib/server/auth.ts"

export const logoutForm = form(async () => {
	const { cookies, locals } = getRequestEvent()
	const { session } = await authorise(locals)

	await invalidateSession(session)
	cookies.delete(cookieName, { path: "/" })

	redirect(302, "/login")
})

// hooks.server.ts updates the user's status when pinged
export const statusPing = command(async () => {})
