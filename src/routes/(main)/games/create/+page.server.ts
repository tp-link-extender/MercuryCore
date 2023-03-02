import type { Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import { fail, redirect } from "@sveltejs/kit"

export const actions: Actions = {
	default: async ({ locals, request }) => {
		const user = (await authoriseUser(locals.validateUser())).user

		const data = await request.formData()
		const name = data.get("name")?.toString() || ""
		const description = data.get("description")?.toString()

		const slug = name.toLowerCase()

		if (!name || !description) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 50 || description.length > 1000) return fail(400, { msg: "Invalid fields" })

		if (
			await prisma.place.findUnique({
				where: {
					name,
				},
			})
		)
			return fail(400, { msg: "A place with this name already exists" })

		try {
			await prisma.$transaction(async tx => {
				await transaction({ id: user.userId }, { number: 1 }, 10, { note: `Created place ${name}`, link: `/place/${slug}` }, tx)

				await tx.place.create({
					data: {
						name,
						slug,
						description,
						serverIP,
						serverPort,
						maxPlayers,
						image: `/place/placeholderIcon${Math.floor(Math.random() * 3) + 1}.png`,
						ownerUsername: user.username,
					},
				})
			})
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		throw redirect(302, `/place/${slug}`)
	},
}
