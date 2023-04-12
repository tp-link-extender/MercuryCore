import { authorise } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import id, { rollback } from "$lib/server/id"
import type { ItemCategory } from "@prisma/client"
import { redirect } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().min(3).max(50),
	price: z.number().min(0).max(9999),
	category: z.enum([
		"TShirt",
		"Shirt",
		"Pants",
		"HeadShape",
		"Hair",
		"Face",
		"Skirt",
		"Dress",
		"Hat",
		"Headgear",
		"Gear",
		"Neck",
		"Back",
		"Shoulder",
	]),
})

export const load = () => ({
	form: superValidate(schema),
})

export const actions = {
	default: async ({ request, locals }) => {
		const { user } = await authorise(locals)

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { name, price, category } = form.data

		let item
		const itemId = await id()
		try {
			item = await prisma.$transaction(async tx => {
				const created = await tx.item.create({
					data: {
						id: itemId,
						name,
						price: price || 0,
						category: category as ItemCategory,
						creatorName: user.username,
						mesh: "",
						texture: "",
						owners: {
							connect: {
								id: user.id,
							},
						},
					},
				})
				await transaction(
					{ id: user.id },
					{ number: 1 },
					10,
					{
						note: `Created item ${name}`,
						link: `/avatarshop/item/${created.id}`,
					},
					tx
				)
				return created
			})
		} catch (e: any) {
			rollback(itemId)
			return formError(form, ["other"], [e.message])
		}

		throw redirect(302, `/avatarshop/item/${item.id}`)
	},
}
