import { error } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

export async function load({ params }: { params: any }) {
	const getPlace = await prisma.place.findUnique({
		where: {
			name_ownerUsername: {
				name: params.place,
				ownerUsername: params.user,
			},
		},
		select: {
			description: true,
			image: true,
		},
	})
	if (getPlace) {
		return {
			name: params.place,
			owner: params.user,
			description: getPlace.description,
			image: getPlace.image,
		}
	} else {
		throw error(404, `Not found: /${params.place}`)
	}
}
