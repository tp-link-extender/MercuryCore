import type { PageServerLoad } from "./$types"
import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

export const load: PageServerLoad = async () => {
	const getPlaces = await prisma.place.findMany({
		select: {
			name: true,
			slug: true,
			image: true,
		},
	})
	return {
		places: getPlaces || [],
	}
}
