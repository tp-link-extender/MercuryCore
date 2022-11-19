import type { PageServerLoad } from "./$types"
import { PrismaClient } from "@prisma/client"
import { redirect } from "@sveltejs/kit"

const prisma = new PrismaClient()

export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.getSession()
	if (!session) throw redirect(302, "/login")

	const getPlaces = await prisma.place.findMany({
		select: {
			name: true,
			ownerUsername: true,
			image: true,
		},
	})
	const user = await prisma.user.findUnique({
		where: {
			id: session.userId,
		},
		select: {
			friends: {
				select: {
					username: true,
					displayname: true,
					image: true,
					Status: true,
				},
			},
		},
	})
	return {
		places: getPlaces || [],
		friends: user?.friends || [],
	}
}
