import type { Actions } from "./$types"
import { redirect, fail } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = data.get("username")?.toString() || ""
		const email = data.get("email")?.toString() || ""
		const password = data.get("password")?.toString() || ""
		const cpassword = data.get("cpassword")?.toString() || ""
		const regkey = data.get("regkey")?.toString() || ""
		
		

		const easyChecks = [
			[username.length <= 3, "Username must be more than 3 characters", "username"],
			[username.length > 30, "Username must be less than 30 characters", "username"],
			[!username.match(/^[A-Za-z0-9_]+$/), "Username must be alphanumeric (A-Z, 0-9, _)", "username"],
			[regkey != "mercurkey-123", "Invalid registration key", "regkey"],
			[password.length < 1, "Password must be at least 1 character", "password"],
			[password.length > 6969, "Password must be less than 6969 characters", "password"],
			[cpassword != password, "The specified password does not match", "cpassword"]
		]

		for (const [condition, msg, area] of easyChecks) {
			if (condition) {
				return fail(400, { msg, area })
			}
		}

		// Since each user's page is a route, we need to make sure it doesn't clash with existing routes
		const lowercaseUsername = username.toLowerCase()
		for (let i in import.meta.glob("/src/routes/**")) {
			let t = i.substring(19)
			t = t.substring(0, t.indexOf("/"))

			if (t.toLowerCase() == lowercaseUsername) return fail(400, { msg: "Username is unavailable" })
		}

		try {
			const caseInsensitiveCheck = await prisma.user.findMany({
				where: {
					username: {
						equals: username,
						mode: "insensitive",
					},
				},
			})

			if (caseInsensitiveCheck.length > 0) return fail(400, { msg: "User already exists" })

			const user = await auth.createUser("username", username, {
				password,
				attributes: {
					username,
					email,
					displayname: username,
					usedInvite: regkey, 
					image: "https://tr.rbxcdn.com/54d17964492b5e0af66797942fcce26c/150/150/AvatarHeadshot/Png",
				},
			})
			
			const session = await auth.createSession(user.userId)
			locals.setSession(session)
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_DUPLICATE_PROVIDER_ID") {
				return fail(400, { msg: "User already exists" })
			}
			console.error(error)
			return fail(500, { area: "unexp", msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
