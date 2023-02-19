import type { PageServerLoad, Actions } from "./$types"
import { prisma, transaction } from "$lib/server/prisma"
import type { ItemCategory } from "@prisma/client"
import { fail, error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async () => {
	return {}
}

export const actions: Actions = {
	default: async ({ locals, request }) => {
		const session = await locals.validateUser()
		if (!session.session) throw error(401)

		const data = await request.formData()
		const name = data.get("name")?.toString()

		if (!name) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 40) return fail(400, { msg: "Invalid fields" })
		if (name == "wisely")
			return fail(400, {
				msg: "GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!"
			})

		try {
			await transaction({ id: session.user.userId }, { number: 1 }, 10)
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		await prisma.group.create({
			data: {
				name,
				ownerUsername: session.user.username,
			},
		})

		throw redirect(302, "/groups/" + name)
	},
}
