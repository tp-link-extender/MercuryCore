import type { PageServerLoad } from "./$types"
import { error, redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import { createClient, Graph } from "redis"

const prisma = new PrismaClient()

export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.validate()
	if (!session) throw redirect(302, "/login")

	const getPlaces = await prisma.place.findMany({
		select: {
			name: true,
			ownerUsername: true,
			image: true,
		},
	})
	return {
		places: getPlaces || [],
		friends: [],
	}
}
