// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"
import { auth, authorise } from "$lib/server/lucia"
import { error, redirect } from "@sveltejs/kit"

export function load() {
	throw error(
		451,
		Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"),
	)
}

export const actions = {
	logout: async ({ locals }) => {
		const { session } = await authorise(locals)

		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.auth.setSession(null) // remove cookie
		throw redirect(302, "/login")
	},
	statusping: async ({ locals }) => {
		const { user } = await authorise(locals)

		await query(surql`UPDATE $user SET lastOnline = time::now()`, {
			user: `user:${user.id}`,
		})
	},
}
