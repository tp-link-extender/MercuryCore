import type { PageServerLoad, Actions } from "./$types"
import { error, fail, redirect } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"

export const load: PageServerLoad = async () => {
	throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export const actions: Actions = {
	default: async ({ locals }) => {
		const session = await locals.validate()
		if (!session) return fail(401)
		await auth.invalidateSession(session.sessionId) // invalidate session
		locals.setSession(null) // remove cookie
		throw redirect(302, "/login")
	},
}
