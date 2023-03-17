import { authoriseUser } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import { fail, redirect } from "@sveltejs/kit"

export const actions = {
	default: async ({ locals, request }) => {
		const user = (await authoriseUser(locals.validateUser)).user

		const data = await request.formData()
		const name = (data.get("name") as string).trim()
		const description = (data.get("description") as string).trim()
		const serverIP = (data.get("serverIP") as string).trim()
		const serverPort = parseInt(data.get("serverPort") as string)
		const maxPlayers = parseInt(data.get("maxPlayers") as string)
		const privateServer = !!data.get("privateServer")

		console.log(
			name,
			description,
			serverIP,
			serverPort,
			maxPlayers,
			privateServer
		)

		if (!name || !description || !serverIP || !serverPort || !maxPlayers)
			return fail(400, { msg: "Missing fields" })
		if (
			name.length < 3 ||
			name.length > 50 ||
			description.length > 1000 ||
			serverPort > 65535 ||
			serverPort < 25565 ||
			maxPlayers > 99 ||
			maxPlayers < 1 ||
			!/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(
				serverIP
			)
		)
			return fail(400, { msg: "Invalid fields" })

		const gameCount = await prisma.user.findUnique({
			where: { id: user.userId },
			select: { _count: { select: { places: true } } },
		})

		if (gameCount && gameCount?._count.places >= 2)
			return fail(400, { msg: "You may only have 2 places at most" })

		let place: any
		try {
			await prisma.$transaction(async tx => {
				place = await tx.place.create({
					data: {
						name,
						description,
						serverIP,
						serverPort,
						privateServer,
						maxPlayers,
						image: `/place/placeholderIcon${
							Math.floor(Math.random() * 3) + 1
						}.png`,
						ownerUsername: user.username,
					},
					select: {
						id: true,
					},
				})

				await transaction(
					{ id: user.userId },
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
			return fail(402, { msg: e.message })
		}

		throw redirect(302, `/place/${place.id}`)
	},
}
