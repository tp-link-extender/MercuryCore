import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").RequestHandler} */
export async function GET() {
	const getPlaces = await prisma.place.findMany({
		select: {
			name: true,
			ownerUsername: true,
			image: true,
		},
	})
	return {
		body: {
			places: getPlaces || [],
		},
	}
}
