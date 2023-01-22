import type { PageServerLoad } from "./$types"
import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

export const load: PageServerLoad = async () => {
	return {
		places: prisma.place.findMany({
			select: {
				name: true,
				slug: true,
				image: true,
			},
		}),
	}
}
