import type { PageServerLoad } from "./$types"
import { redirect, invalid } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.getSession()
	if (session) throw redirect(302, "/home")
}

/** @type {import("./$types").Actions} */
export const actions = {
	default: async ({ request }: { request: any }) => {
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

		// Since each user's page is a route, we need to make sure it doesn't clash with existing routes
		const lowercaseUsername = username.toLowerCase()
		for (let i in import.meta.glob("/src/routes/**")) {
			let t = i.substring(12)
			t = t.substring(0, t.indexOf("/"))

			if (t.toLowerCase() == lowercaseUsername) return invalid(400, { msg: "Username is unavailable" })
		}

		try {
			const createUser = await auth.createUser("username", username, {
				password,
				attributes: {
					username,
					displayname: username,
					image: "https://tr.rbxcdn.com/63fbca28e1fc28ed99915db948255b81/150/150/AvatarHeadshot/Png",
				},
			})
			const session = await auth.createSession(createUser.userId)
			locals.setSession(session)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_DUPLICATE_PROVIDER_ID") {
				return invalid(400, { msg: "User already exists" })
			}
			console.error(error)
			return invalid(500, { msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
