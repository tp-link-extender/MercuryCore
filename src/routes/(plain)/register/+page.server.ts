import type { Actions } from "./$types"
import { redirect, fail } from "@sveltejs/kit"
import { auth } from "$lib/server/lucia"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const data = await request.formData()
		const username = data.get("username")?.toString() || ""
		const email = data.get("email")?.toString().toLowerCase() || ""
		const password = data.get("password")?.toString() || ""
		const cpassword = data.get("cpassword")?.toString() || ""
		const regkey = data.get("regkey")?.toString().split("-") || ""

		if (username.length < 3) return fail(400, { area: "username", msg: "Username must be more than 3 characters" })
		if (username.length > 30) return fail(400, { area: "username", msg: "Username must be less than 30 characters" })
		if (!username.match(/^[A-Za-z0-9_]+$/)) return fail(400, { area: "username", msg: "Username must be alphanumeric (A-Z, 0-9, _)" })
		if (password.length < 1) return fail(400, { area: "password", msg: "Password must be at least 1 character" })
		if (password.length > 6969) return fail(400, { area: "password", msg: "Password must be less than 6969 characters" })
		if (cpassword != password) return fail(400, { area: "cpassword", msg: "The specified password does not match" })

		// Since each user's page is a route, we need to make sure it doesn't clash with existing routes
		const lowercaseUsername = username.toLowerCase()
		for (let i in import.meta.glob("/src/routes/**")) {
			let t = i.substring(19)
			t = t.substring(0, t.indexOf("/"))

			if (t.toLowerCase() == lowercaseUsername) return fail(400, { area: "username", msg: "Username is unavailable" })
		}

		try {
			const userCheck = await prisma.user.findUnique({
				where: {
					username: lowercaseUsername,
				},
			})
			if (userCheck) return fail(400, { area: "username", msg: "Username is already being used" })

			const emailCheck = await prisma.user.findUnique({
				where: {
					email: email.toLowerCase(),
				},
			})
			if (emailCheck) return fail(400, { area: "email", msg: "Email is already being used" })

			const regkeyCheck = await prisma.regkey.findUnique({
				where: {
					key: regkey[1] || "",
				},
			})
			if (!regkeyCheck) return fail(400, { area: "regkey", msg: "Registration key is invalid" })
			if (regkeyCheck.usesLeft < 1) return fail(400, { area: "regkey", msg: "This registration key has ran out of uses" })

			const user = await auth.createUser("username", username, {
				password,
				attributes: {
					username: lowercaseUsername,
					email,
					displayname: username,
					usedRegkey: {
						connect: {
							key: regkey[1],
						},
					},
					image: "https://tr.rbxcdn.com/54d17964492b5e0af66797942fcce26c/150/150/AvatarHeadshot/Png",
				},
			})

			const session = await auth.createSession(user.userId)
			locals.setSession(session)

			await prisma.regkey.update({
				where: { key: regkey[1] },
				data: { usesLeft: { decrement: 1 } },
			})
		} catch (e) {
			const error = e as Error
			if (error.message === "AUTH_DUPLICATE_PROVIDER_ID") {
				return fail(400, { area: "username", msg: "User already exists" })
			}
			console.error("Registration error:", error)
			return fail(500, { area: "unexp", msg: "An unexpected error occurred" })
		}

		throw redirect(302, "/home")
	},
}
