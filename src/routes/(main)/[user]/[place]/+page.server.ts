import { error } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
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
			img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
			description: getPlace.description,
			image: getPlace.image,
		}
	} else {
		throw error(404, `Not found: /${params.place}`)
	}
}
