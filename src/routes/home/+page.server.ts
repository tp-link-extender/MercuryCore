import { PrismaClient } from "@prisma/client"
import { redirect } from "@sveltejs/kit"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export async function load({ parent }: { parent: any }) {
	const { lucia } = await parent()
	if (!lucia) throw redirect(302, "/login")
	
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
