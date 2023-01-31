import type { Actions } from "./$types"
import { redirect, fail } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = data.get("username")?.toString() || ""
		const password = data.get("password")?.toString() || ""

		if (username.length < 3) return fail(400, { area: "username", msg: "Username must be at least 3 characters" })
		if (username.length > 30) return fail(400, { area: "username", msg: "Username must be less than 30 characters" })
		if (password.length < 1) return fail(400, { area: "password", msg: "Password must be at least 1 character" })
		if (password.length > 6969) return fail(400, { area: "password", msg: "Password must be less than 6969 characters" })

		let session
		try {
			const user = await auth.validateKeyPassword("username", username.toLowerCase(), password)
			session = await auth.createSession(user.userId)
		} catch (e) {
			console.error("Login error:", e as Error)
			return fail(400, { area: "password", msg: "Incorrect username or password" })
		}
		locals.setSession(session)

		throw redirect(302, "/home")
	},
}
