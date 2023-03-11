import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { error, type Actions, fail } from "@sveltejs/kit"
import { createId } from "@paralleldrive/cuid2"
import { v4 as uuid } from "uuid"

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id)) throw error(400, `Invalid game id: ${params.id}`)

	console.time("place settings")
	const getPlace = await prisma.place.findUnique({
		where: {
			id: parseInt(params.id),
		},
		select: {
			id: true,
			name: true,
			description: true,
			image: true,
			maxPlayers: true,
			serverTicket: true,
			serverIP: true,
			serverPort: true,
			privateServer: true,
			privateTicket: true,
			ownerUser: {
				select: {
					number: true,
					username: true,
				},
			},
		},
	})
	console.timeEnd("place settings")

	if (!getPlace) throw error(404, "Not found")

	const { user } = await authoriseUser(locals.validateUser)

	if (user.number != getPlace.ownerUser?.number && user.permissionLevel < 4) throw error(401, "You do not have permission to view this page.")

	return getPlace
}

export const actions = {
	default: async ({ request, locals, params }) => {
		if (!/^\d+$/.test(params.id || "")) throw error(400, `Invalid game id: ${params.id}`)
		const id = parseInt(params.id || "")
		const { user } = await authoriseUser(locals.validateUser)

		const getPlace = await prisma.place.findUnique({
			where: {
				id,
			},
			select: {
				id: true,
				name: true,
				description: true,
				serverIP: true,
				serverPort: true,
				serverTicket: true,
				privateServer: true,
				privateTicket: true,
				ownerUser: {
					select: {
						id: true,
					},
				},
			},
		})

		if (user.userId != getPlace?.ownerUser?.id && user.permissionLevel < 4) throw error(401, "You do not have permission to update this page.")

		const data = await request.formData()
		const action = data.get("action") as string

		console.log("Action:", action)

		switch (action) {
			case "view":
				const title = data.get("title") as string
				const description = data.get("desc") as string

				if (title == getPlace?.name && description == getPlace?.description) return fail(400)
				if (!title) return fail(400, { area: "title", msg: "Missing title" })
				if (!description) return fail(400, { area: "description", msg: "Missing description" })

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						name: title,
						description,
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
				const serverIP = data.get("address") as string
				const serverPort = parseInt(data.get("port") as string)

				if (serverIP == getPlace?.serverIP && serverPort == getPlace?.serverPort) return fail(400)
				if (!serverIP) return fail(400, { area: "address", msg: "Missing address" })
				if (!serverPort) return fail(400, { area: "port", msg: "Missing port" })
				if (serverPort > 65535 || serverPort < 1024) return fail(400, { area: "port", msg: "Invalid port" })
				if (
					!/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(
						serverIP
					)
				)
					return fail(400, { area: "address", msg: "Invalid address" })

				await prisma.place.update({
					where: {
						id,
					},
					data: {
						serverIP,
						serverPort,
					},
				})

				return {
					networksuccess: true,
					serverIP,
					serverPort,
				}

			case "privacy":
				const privateServer = !!data.get("privacy")

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
