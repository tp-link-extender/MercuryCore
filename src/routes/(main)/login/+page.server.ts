import type { PageServerLoad } from "./$types"
import { redirect, invalid } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"

/** @type {import("@sveltejs/kit").PageServerLoad} */
export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.getSession()
	if (session) throw redirect(302, "/home")
}

/** @type {import("./$types").Actions} */
export const actions = {
	default: async ({ request, locals }: { request: any; locals: any }) => {
		const data = await request.formData()
		const username = data.get("username")
		const password = data.get("password")

		const easyChecks = [
			[username.length <= 3, "Username must be more than 3 characters"],
			[username.length > 30, "Username must be less than 30 characters"],
			[password.length < 16, "Password must be at least 16 characters"],
			[password.length > 6969, "Password must be less than 6969 characters"],
		]

		for (const [condition, msg] of easyChecks) {
			if (condition) {
				return invalid(400, { msg })
			}
		}

		try {
			const user = await auth.authenticateUser("username", username, password)
			const session = await auth.createSession(user.userId)
			locals.setSession(session)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_INVALID_PROVIDER_ID" || error.message === "AUTH_INVALID_PASSWORD") {
				return invalid(400, { msg: "Incorrect username or password" })
			}
			console.error(error)
			return invalid(500, { msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
