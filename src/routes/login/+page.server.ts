import { error, redirect } from "@sveltejs/kit"

/** @type {import("./$types").Actions} */
export const actions = {
	default: async ({ request }: { request: any }) => {
		console.log(request)
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

		throw redirect(302, "/home")
	},
}
