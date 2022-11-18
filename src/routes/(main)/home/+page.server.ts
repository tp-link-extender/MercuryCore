import type { PageServerLoad } from "./$types"
import { PrismaClient } from "@prisma/client"
import { redirect } from "@sveltejs/kit"

const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
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
	return {
		places: getPlaces || [],
	}
}
