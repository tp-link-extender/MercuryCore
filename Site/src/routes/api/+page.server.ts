// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import { error, redirect } from "@sveltejs/kit"
import { authorise, cookieName, invalidateSession } from "$lib/server/auth"
import type { Actions } from "./$types"

const msg = Buffer.from("ZHVtYiBuKiBkZXRlY3RlZA==", "base64").toString()

export function load() {
	error(403, msg)
}

export const actions: Actions = {}
actions.logout = async ({ cookies, locals }) => {
	const { session } = await authorise(locals)

	await invalidateSession(session)
	cookies.delete(cookieName, { path: "/" })

	redirect(302, "/login")
}
actions.statusping = () => {
	// does nothing
	// hooks.server.ts will update the user's status when pinged
}
