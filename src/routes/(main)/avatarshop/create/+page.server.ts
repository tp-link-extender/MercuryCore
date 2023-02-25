import type { Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import type { ItemCategory } from "@prisma/client"
import { fail, redirect } from "@sveltejs/kit"

export const actions: Actions = {
	default: async ({ locals, request }) => {
		const user = (await authoriseUser(locals.validateUser())).user

		const data = await request.formData()
		const name = data.get("name")?.toString()
		const price = Number(data.get("price"))
		const category = data.get("category")?.toString()

		if (!name || !category) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 50 || price < 0 || !["TShirt", "Shirt", "Pants", "HeadShape", "Hair", "Face", "Skirt", "Dress", "Hat", "Headgear", "Gear", "Neck", "Back", "Shoulder"].includes(category)) return fail(400, { msg: "Invalid fields" })

		let item
		try {
			item = await prisma.$transaction(async tx => {
				const created = await tx.item.create({
					data: {
						name,
						price: price || 0,
						category: category as ItemCategory,
						creatorName: user.username,
						mesh: "",
						texture: "",
						owners: {
							connect: {
								id: user.userId,
							},
						},
					},
					select: {
						id: true,
					},
				})
				await transaction({ id: user.userId }, { number: 1 }, 10, { note: `Created item ${name}`, link: `/item/${created.id}` }, tx)
				return created
			})
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		throw redirect(302, `/item/${item.id}`)
	},
}
