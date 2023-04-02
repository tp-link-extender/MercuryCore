import { authorise } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import { redirect } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().min(3).max(40),
})

export const load = async (event /**/) => ({
	form: await superValidate(event, schema),
})

export const actions = {
	default: async event => {
		const { user } = await authorise(event.locals)

		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const { name } = form.data

		if (name == "create")
			return formError(
				form,
				["name"],
				[
					Buffer.from(
						"RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ",
						"base64"
					).toString("ascii"),
				]
			)
		if (name == "wisely")
			return formError(
				form,
				["name"],
				["GRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!"]
			)

		if (
			await prisma.group.findUnique({
				where: {
					name,
				},
			})
		)
			return formError(
				form,
				["name"],
				["A group with this name already exists"]
			)

		try {
			await prisma.$transaction(async tx => {
				await transaction(
					{ id: user.id },
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
			return formError(form, ["other"], [e.message])
		}

		throw redirect(302, `/groups/${name}`)
	},
}
