import type { PageServerLoad, Actions } from './$types';
import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, redirect, json, fail } from "@sveltejs/kit"

export const load: PageServerLoad = (async ({ locals, params }) => {
    console.time("place settings")
	const getPlace = await prisma.place.findUnique({
		where: {
			slug: params.place,
		},
		select: {
			id: true,
			name: true,
			description: true,
			image: true,
			maxPlayers: true,
			created: true,
			updated: true,
			serverTicket: true,
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
		const { session, user } = await authoriseUser(locals.validateUser())

        if(user.number != getPlace.ownerUser?.number && user.permissionLevel != "Administrator" || user.number != getPlace.ownerUser?.number && user.permissionLevel != "Moderator") 
            throw error(401, "You do not have permission to view this page.")

		const query = {
			params: {
				user: user?.username || "",
				place: params.place,
			},
		}

		return {
			id: getPlace.id,
			name: getPlace.name,
			owner: getPlace.ownerUser,
			description: getPlace.description,
			image: getPlace.image,
			maxPlayers: getPlace.maxPlayers,
			created: getPlace.created,
			updated: getPlace.updated,
			slug: params.place,
			serverTicket: getPlace.serverTicket,
		}
	} else throw error(404, "Not found")

}) 