import type { Actions } from "./$types"
import { prisma } from "$lib/server/prisma"
import { auth } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"

export const actions: Actions = {
	profile: async ({ request, locals }) => {
		const data = await request.formData()
		const session = await locals.validateUser()
		const entries: any = Object.fromEntries(data.entries())

		if (session.user.bio == data.get("bio") && session.user.displayname == data.get("displayname")) return fail(400)
		// nothing changed

		if (!entries.displayName) return fail(400, { area: "displayName", msg: "Invalid displayname" })

		await prisma.user.update({
			where: {
				number: session.user.number,
			},
			data: {
				bio: entries.bio || "",
				displayname: entries.displayName,
			},
		})

		return {
			profilesuccess: true,
			prev: entries,
		}
	},

	password: async ({ request, locals }) => {
		const data = await request.formData()
		const session = await locals.validateUser()
		const entries: any = Object.fromEntries(data.entries())

		if (entries.npassword != entries.cnpassword) return fail(400, { area: "cnpassword", msg: "Passwords do not match" })

		try {
			await auth.validateKeyPassword("username", session.user.username, entries.cpassword)
		} catch {
			return fail(400, { area: "cpassword", msg: "Incorrect username or password" })
		}

		await auth.updateKeyPassword("username", session.user.username, entries.npassword)

		return {
			passwordsuccess: true,
		}
	},
}
