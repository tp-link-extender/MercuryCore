import type { PageServerLoad } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { error } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {

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
	if (getPlace) {
		const user = (await authoriseUser(locals.validateUser)).user

		if (user.number != getPlace.ownerUser?.number && user.permissionLevel >= 4) throw error(401, "You do not have permission to view this page.")

		return {
            ...getPlace
		}
	} else throw error(404, "Not found")
}
