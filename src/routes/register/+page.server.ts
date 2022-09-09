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
			if (condition) throw redirect(302, `/register#${code || "error"}`)
		}

		try {
			const createUser = await auth.createUser("username", username, {
				password,
				user_data: {
					username,
					image: "https://tr.rbxcdn.com/63fbca28e1fc28ed99915db948255b81/150/150/AvatarHeadshot/Png",
				},
			})
			console.log("cookys", createUser.cookies)
			cookies.set(createUser.cookies)
		} catch {
			throw redirect(302, `/register#error`)
		}

		throw redirect(302, "/home")
	},
}
