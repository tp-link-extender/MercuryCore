import { auth } from "$lib/server/lucia"
import formData from "$lib/server/formData"
import { redirect, fail } from "@sveltejs/kit"

export const actions = {
	default: async ({ request, locals }) => {
		const data = await formData(request)
		const username = data.username
		const password = data.password

		if (username.length < 3)
			return fail(400, {
				area: "username",
				msg: "Username must be at least 3 characters",
			})
		if (username.length > 30)
			return fail(400, {
				area: "username",
				msg: "Username must be less than 30 characters",
			})
		if (password.length < 1)
			return fail(400, {
				area: "password",
				msg: "Password must be at least 1 character",
			})
		if (password.length > 6969)
			return fail(400, {
				area: "password",
				msg: "Password must be less than 6969 characters",
			})

		if (username.includes("["))
			return fail(400, { area: "username", msg: "Invalid username" })

		let session
		try {
			const user: any = await auth.useKey(
				"username",
				username.toLowerCase(),
				password
			)
			session = await auth.createSession(user.userId)
		} catch {
			return fail(400, {
				area: "password",
				msg: "Incorrect username or password",
			})
		}
		locals.setSession(session)

		throw redirect(302, "/home")
	},
}
