import { redirect } from "@sveltejs/kit"
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
			[username.length <= 3, "ushort"],
			[username.length > 30, "ulong"],
			[password.length < 16, "pshort"],
			[password.length > 6969, "plong"],
		]

		for (const [condition, code] of easyChecks) {
			if (condition) throw redirect(302, `/login#${code || "error"}`)
		}

		try {
			const authenticateUser = await auth.authenticateUser("username", username, password)
			cookies.set(authenticateUser.cookies)
		} catch (e) {
			console.log(e)
			throw redirect(302, `/login#error`)
		}

		throw redirect(302, "/home")
	},
}
