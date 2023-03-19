import { authoriseUser } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import formData from "$lib/server/formData"
import { fail, redirect } from "@sveltejs/kit"

export const actions = {
	default: async ({ locals, request }) => {
		const user = (await authoriseUser(locals.validateUser)).user

		const data = await formData(request)
		const name = data.name

		if (!name) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 40)
			return fail(400, { msg: "Invalid fields" })
		if (name == "create")
			return fail(400, {
				msg: Buffer.from(
					"RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ",
					"base64"
				).toString("ascii"),
			})
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
				await transaction(
					{ id: user.userId },
					{ number: 1 },
					10,
					{ note: `Created group ${name}`, link: `/groups/${name}` },
					tx
				)

				await tx.group.create({
					data: {
						name,
						ownerUsername: user.username,
					},
				})
			})
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		throw redirect(302, `/groups/${name}`)
	},
}
