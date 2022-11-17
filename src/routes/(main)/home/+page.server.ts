import { PrismaClient } from "@prisma/client"
import { redirect } from "@sveltejs/kit"
import { auth } from "$lib/lucia"

const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export const load = auth.handleServerLoad(async ({ getSession }) => {
	const session = await getSession()
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
	}
})
