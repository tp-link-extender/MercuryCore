import { redirect, invalid } from "@sveltejs/kit"
import { auth } from "$lib/lucia"

export async function load({ parent }: { parent: any }) {
	const { lucia } = await parent()
	if (lucia) throw redirect(302, "/home")
}

/** @type {import("./$types").Actions} */
export const actions = {
	default: async ({ cookies, request }: { cookies: any; request: any }) => {
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
			const authenticateUser = await auth.authenticateUser("username", username, password)
			cookies.set(authenticateUser.cookies)
		} catch (e) {
			console.log(e)
			throw redirect(302, "/login")
		}

		throw redirect(302, "/home")
	},
}
