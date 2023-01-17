import type { Actions } from "./$types"
import { redirect, fail } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = data.get("username")?.toString() || ""
		const password = data.get("password")?.toString() || ""

		const easyChecks = [
			[username.length <= 3, "Username must be more than 3 characters", "username"],
			[username.length > 30, "Username must be less than 30 characters", "username"],
			[password.length < 1, "Password must be at least 1 character", "password"],
			[password.length > 6969, "Password must be less than 6969 characters", "password"],
		]

		for (const [condition, msg, area] of easyChecks) {
			if (condition) {
				return fail(400, { msg, area })
			}
		}

		try {
			const user = await auth.authenticateUser("username", username, password)
			const session = await auth.createSession(user.userId)
			locals.setSession(session)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_INVALID_PROVIDER_ID" || error.message === "AUTH_INVALID_PASSWORD") {
				return fail(400, { area: "username", msg: "Incorrect username or password" })
			}
			console.error(error)
			return fail(500, { area: "unexp", msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
