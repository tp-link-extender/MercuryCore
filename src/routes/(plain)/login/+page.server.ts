import type { Actions } from "./$types"
import { redirect, fail } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = data.get("username")?.toString() || ""
		const password = data.get("password")?.toString() || ""

		if (username.length <= 3) return fail(400, { area: "username", msg: "Username must be more than 3 characters" })
		if (username.length > 30) return fail(400, { area: "username", msg: "Username must be less than 30 characters" })
		if (password.length < 1) return fail(400, { area: "password", msg: "Password must be at least 1 character" })
		if (password.length > 6969) return fail(400, { area: "password", msg: "Password must be less than 6969 characters" })

		try {
			const user = await auth.authenticateUser("username", username, password)
			const session = await auth.createSession(user.userId)
			locals.setSession(session)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_INVALID_PROVIDER_ID" || error.message === "AUTH_INVALID_PASSWORD") {
				return fail(400, { area: "password", msg: "Incorrect username or password" })
			}
			console.error(error)
			return fail(500, { area: "unexp", msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
