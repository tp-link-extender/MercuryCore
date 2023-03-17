import { auth, authoriseAdmin } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)
}

export const actions = {
	resetPassword: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const limit = ratelimit("resetPassword", getClientAddress, 30)
		if (limit) return limit

		const data = await request.formData()
		const username = (data.get("username") as string).trim()
		const password = (data.get("password") as string).trim()

		if (!username || !password) return fail(400, { msg: "Missing fields" })

		try {
			await auth.updateKeyPassword(
				"username",
				username.toLowerCase(),
				password
			)
		} catch {
			return fail(400, { msg: "Invalid credentials" })
		}

		return {
			usersuccess: true,
			msg: "Password changed successfully!",
		}
	},
}
