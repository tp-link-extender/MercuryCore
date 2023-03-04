// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import type { PageServerLoad, Actions } from "./$types"
import { auth, authorise } from "$lib/server/lucia"
import { error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async () => {
	throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export const actions: Actions = {
	logout: async ({ locals }) => {
		const session = await authorise(locals.validate)

		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.setSession(null) // remove cookie
		throw redirect(302, "/login")
	},
}
