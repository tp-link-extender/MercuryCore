import { authorise } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import { redirect } from "@sveltejs/kit"
import formError from "$lib/server/formError"
import { superValidate } from "sveltekit-superforms/server"
import { z } from "zod"

const schema = z.object({
	name: z.string().min(3).max(50),
	description: z.string().max(1000),
	serverIP: z
		.string()
		.regex(
			/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
		),
	serverPort: z.number().min(25565).max(65535).default(53640),
	maxPlayers: z.number().min(1).max(99).default(10),
	privateServer: z.boolean().optional(),
})

export const load = async (event /**/) => ({
	form: await superValidate(event, schema),
})

export const actions = {
	default: async event => {
		const { user } = await authorise(event.locals)

		const form = await superValidate(event, schema)
		if (!form.valid) return formError(form)

		const {
			name,
			description,
			serverIP,
			serverPort,
			maxPlayers,
			privateServer,
		} = form.data

		console.log("Place create", form.data)

		const gameCount = await prisma.authUser.findUnique({
			where: {
				id: user.id,
			},
			select: {
				_count: true,
			},
		})

		if (gameCount && gameCount?._count.places >= 2)
			return formError(
				form,
				["other"],
				["You may only have 2 places at most"]
			)

		let place: any
		try {
			await prisma.$transaction(async tx => {
				place = await tx.place.create({
					data: {
						name,
						description: {
							create: {
								text: description,
							},
						},
						serverIP,
						serverPort,
						privateServer,
						maxPlayers,
						image: `/place/placeholderIcon${
							Math.floor(Math.random() * 3) + 1
						}.png`,
						ownerUsername: user.username,
					},
				})

				await transaction(
					{ id: user.id },
					{ number: 1 },
					10,
					{
						note: `Created place ${name}`,
						link: `/place/${place.id}`,
					},
					tx
				)
			})
		} catch (e: any) {
			return formError(form, ["other"], [e.message])
		}

		throw redirect(302, `/place/${place.id}`)
	},
}
