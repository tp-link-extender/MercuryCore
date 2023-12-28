// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import { auth, authorise } from "$lib/server/lucia"
import { error, redirect } from "@sveltejs/kit"

const msg = Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString()

export function load() {
	error(451, msg)
}

export const actions = {
	logout: async ({ locals }) => {
		const { session } = await authorise(locals)

		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.auth.setSession(null) // remove cookie
		redirect(302, "/login")
	},
	statusping: () => {
		// does nothing
		// hooks.server.ts will update the user's status when pinged
	},
}
