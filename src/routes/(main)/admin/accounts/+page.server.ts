import { auth, authoriseAdmin } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)
}

export const actions = {
	resetPassword: async ({ request, locals, getClientAddress }) => {
		await authoriseAdmin(locals)

		const limit = ratelimit("resetPassword", getClientAddress, 30)
		if (limit) return limit

		const data = await formData(request)
		const username = data.username
		const password = data.password

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
