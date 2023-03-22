import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import formData from "$lib/server/formData"
import { error, fail } from "@sveltejs/kit"
import { createId } from "@paralleldrive/cuid2"
import { v4 as uuid } from "uuid"

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
				take: 1,
			},
		},
	})
	console.timeEnd("place settings")

	if (!getPlace) throw error(404, "Not found")

	const { user } = await authorise(locals.validateUser)

	if (user.number != getPlace.ownerUser?.number && user.permissionLevel < 4)
		throw error(401, "You do not have permission to view this page.")

	return getPlace
}

export const actions = {
	default: async ({ request, locals, params }) => {
		if (!/^\d+$/.test(params.id || ""))
			throw error(400, `Invalid game id: ${params.id}`)
		const id = parseInt(params.id || "")
		const { user } = await authorise(locals.validateUser)

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
					take: 1,
				},
			},
		})

		if (user.id != getPlace?.ownerUser?.id && user.permissionLevel < 4)
			throw error(401, "You do not have permission to update this page.")

		const data = await formData(request)
		const action = data.action

		console.log("Action:", action)

		switch (action) {
			case "view":
				const title = data.title
				const description = data.desc

				if (
					title == getPlace?.name &&
					description == getPlace?.description[0]?.text
				)
					return fail(400)
				if (!title)
					return fail(400, { area: "title", msg: "Missing title" })
				if (!description)
					return fail(400, {
						area: "description",
						msg: "Missing description",
					})

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						name: title,
						description: {
							create: {
								text: description,
							},
						},
					},
				})

				return {
					viewsuccess: true,
					title,
					description,
				}

			case "ticket":
				await prisma.place.update({
					where: {
						id,
					},
					data: {
						serverTicket: createId(),
					},
				})

				return {
					ticketregensuccess: true,
				}

			case "network":
				const serverIP = data.address
				const serverPort = parseInt(data.port)
				const maxPlayers = parseInt(data.serverLimit)

				if (
					serverIP == getPlace?.serverIP &&
					serverPort == getPlace?.serverPort &&
					maxPlayers == getPlace?.maxPlayers
				)
					return fail(400)

				if (!serverIP)
					return fail(400, {
						area: "address",
						msg: "Missing address",
					})

				if (!serverPort)
					return fail(400, { area: "port", msg: "Missing port" })

				if (!maxPlayers)
					return fail(400, {
						area: "maxPlayers",
						msg: "Missing server limit",
					})

				if (serverPort > 65535 || serverPort < 1024)
					return fail(400, { area: "port", msg: "Invalid port" })

				if (maxPlayers > 100 || serverPort < 1)
					return fail(400, {
						area: "port",
						msg: "Invalid server limit",
					})

				if (
					!/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(
						serverIP
					)
				)
					return fail(400, {
						area: "address",
						msg: "Invalid address",
					})

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

				return {
					networksuccess: true,
					serverIP,
					serverPort,
					maxPlayers,
				}

			case "privacy":
				const privateServer = !!data.privacy

				if (privateServer == getPlace?.privateServer) return fail(400)

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

				return {
					privateregensuccess: true,
				}
		}
	},
}
