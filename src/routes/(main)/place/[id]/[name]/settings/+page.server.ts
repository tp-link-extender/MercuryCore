import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import formError from "$lib/server/formError"
import { superValidate, message } from "sveltekit-superforms/server"
import { error } from "@sveltejs/kit"
import { createId } from "@paralleldrive/cuid2"
import { v4 as uuid } from "uuid"
import { z } from "zod"

const schema = z.object({
	action: z.enum(["view", "ticket", "network", "privacy", "privatelink"]),
	title: z.string().max(100).optional(),
	description: z.string().max(1000).optional(),
	serverIP: z
		.string()
		.max(100)
		.regex(
			/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
		)
		.optional(),
	serverPort: z.number().int().min(1024).max(65535).optional(),
	maxPlayers: z.number().int().min(1).max(100).optional(),
	privateServer: z.boolean().optional(),
})

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid game id: ${params.id}`)

	console.time("place settings")
	const getPlace = await prisma.place.findUnique({
		where: {
			id: parseInt(params.id),
		},
		include: {
			ownerUser: true,
			description: {
				orderBy: {
					updated: "desc",
				},
				select: {
					text: true,
				},
				take: 1,
			},
		},
	})
	console.timeEnd("place settings")

	if (!getPlace) throw error(404, "Not found")

	const { user } = await authorise(locals)

	if (user.number != getPlace.ownerUser?.number && user.permissionLevel < 4)
		throw error(403, "You do not have permission to view this page.")

	return {
		...getPlace,
		form: superValidate(schema),
	}
}

export const actions = {
	default: async ({ request, locals, params }) => {
		if (!/^\d+$/.test(params.id || ""))
			throw error(400, `Invalid game id: ${params.id}`)
		const id = parseInt(params.id || "")
		const { user } = await authorise(locals)

		const getPlace = await prisma.place.findUnique({
			where: {
				id,
			},
			include: {
				ownerUser: true,
				description: {
					orderBy: {
						updated: "desc",
					},
					select: {
						text: true,
					},
					take: 1,
				},
			},
		})

		if (user.id != getPlace?.ownerUser?.id && user.permissionLevel < 4)
			throw error(403, "You do not have permission to update this page.")

		const form = await superValidate(request, schema)
		if (!form.valid) return formError(form)

		const { action } = form.data

		console.log("Action:", action)

		switch (action) {
			case "view":
				const { title, description } = form.data

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						name: title,
						description: {
							create: {
								text: description || "",
							},
						},
					},
				})

				return message(form, "View settings updated successfully!")

			case "ticket":
				await prisma.place.update({
					where: {
						id,
					},
					data: {
						serverTicket: createId(),
					},
				})

				return message(form, "Successfully regenerated server ticket")

			case "network":
				const { serverIP, serverPort, maxPlayers } = form.data

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						serverIP,
						serverPort,
						maxPlayers,
					},
				})

				return message(form, "Network settings updated successfully!")

			case "privacy":
				const { privateServer } = form.data

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						privateServer,
					},
				})

				return {
					privatesuccess: true,
					privateServer,
				}

			case "privatelink":
				await prisma.place.update({
					where: {
						id,
					},
					data: {
						privateTicket: uuid(),
					},
				})

				return message(form, "Successfully regenerated private link")
		}
	},
}
