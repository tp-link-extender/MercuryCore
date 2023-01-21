import { error } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

export async function load({ params }: { params: any }) {
	console.time("place")
	const getPlace = await prisma.place.findUnique({
		where: {
			slug: params.place,
		},
		select: {
			name: true,
			description: true,
			image: true,
			ownerUsername: true,
		},
	})
	console.timeEnd("place")
	if (getPlace) {
		return {
			name: getPlace.name,
			owner: getPlace.ownerUsername,
			description: getPlace.description,
			image: getPlace.image,
		}
	} else throw error(404, `Not found: /${params.place}`)
}
