import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export async function load() {
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
