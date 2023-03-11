import { auth } from "$lib/server/lucia"
import { redirect, fail } from "@sveltejs/kit"

export const actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = (data.get("username") as string).trim()
		const password = (data.get("password") as string).trim()

		if (username.length < 3) return fail(400, { area: "username", msg: "Username must be at least 3 characters" })
		if (username.length > 30) return fail(400, { area: "username", msg: "Username must be less than 30 characters" })
		if (password.length < 1) return fail(400, { area: "password", msg: "Password must be at least 1 character" })
		if (password.length > 6969) return fail(400, { area: "password", msg: "Password must be less than 6969 characters" })

		let session
		try {
			const user: any = await auth.validateKeyPassword("username", username.toLowerCase(), password)
			session = await auth.createSession(user.userId)
		} catch {
			return fail(400, { area: "password", msg: "Incorrect username or password" })
		}
		locals.setSession(session)

		throw redirect(302, "/home")
	},
}
