import type { Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { auth } from "$lib/server/lucia"
import { fail } from "@sveltejs/kit"

export const actions: Actions = {
	profile: async ({ request, locals }) => {
		const user = (await authoriseUser(locals.validateUser())).user
		const data = await request.formData()

		const entries: any = Object.fromEntries(data.entries())

		let same
		for (let i in entries)
			if (entries[i] != (user as any)[i]) {
				same = false
				break
			}
		if (same) return fail(400)

		if (!entries.displayName) return fail(400, { area: "displayName", msg: "Invalid displayname" })
		if (!["standard", "darken", "storm", "solar"].includes(entries.theme)) return fail(400, { area: "theme", msg: "Invalid theme" })
		if (!["on", "off"].includes(entries.animation)) return fail(400, { area: "theme", msg: "Invalid animation settings" })

		await prisma.user.update({
			where: {
				number: user.number,
			},
			data: {
				bio: entries.bio || "",
				displayname: entries.displayName,
				theme: entries.theme,
			},
		})

		return {
			profilesuccess: true,
		}
	},

	password: async ({ request, locals }) => {
		const user = (await authoriseUser(locals.validateUser())).user
		const data = await request.formData()
		const entries: any = Object.fromEntries(data.entries())

		if (entries.npassword != entries.cnpassword) return fail(400, { area: "cnpassword", msg: "Passwords do not match" })

		try {
			await auth.validateKeyPassword("username", user.username, entries.cpassword)
		} catch {
			return fail(400, { area: "cpassword", msg: "Incorrect username or password" })
		}

		await auth.updateKeyPassword("username", user.username, entries.npassword)

		return {
			passwordsuccess: true,
		}
	},
}
