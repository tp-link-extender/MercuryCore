import type { Actions } from "./$types"
import { prisma, transaction } from "$lib/server/prisma"
import { fail, error, redirect } from "@sveltejs/kit"

export const actions: Actions = {
	default: async ({ locals, request }) => {
		const session = await locals.validateUser()
		if (!session.session) throw error(401)

		const data = await request.formData()
		const name = data.get("name")?.toString()

		if (!name) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 40) return fail(400, { msg: "Invalid fields" })
		if (name == "create") return fail(400, { msg: Buffer.from("RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ", "base64").toString("ascii") })
		if (name == "wisely")
			return fail(400, {
				msg: "GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!",
			})

		if (
			await prisma.group.findUnique({
				where: {
					name,
				},
			})
		)
			return fail(400, { msg: "A group with this name already exists" })

		try {
			await prisma.$transaction(async tx => {
				await transaction({ id: session.user.userId }, { number: 1 }, 10, tx)

				await tx.group.create({
					data: {
						name,
						ownerUsername: session.user.username,
					},
				})
			})
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		throw redirect(302, "/groups/" + name)
	},
}
