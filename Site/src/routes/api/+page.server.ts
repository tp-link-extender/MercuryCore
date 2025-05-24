// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import { authorise, cookieName, invalidateSession } from "$lib/server/auth"
import { error, redirect } from "@sveltejs/kit"

const msg = Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString()

export function load() {
	error(403, msg)
}

export const actions: import("./$types").Actions = {}
actions.logout = async ({ cookies, locals }) => {
	const { session } = await authorise(locals)

	await invalidateSession(session.id)
	cookies.delete(cookieName, { path: "/" })

	redirect(302, "/login")
}
actions.statusping = () => {
	// does nothing
	// hooks.server.ts will update the user's status when pinged
}
