import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").RequestHandler} */
export async function GET({ params }: { params: any }) {
	const getPlace = await prisma.place.findUnique({
		where: {
			name_ownerUsername: {
				name: params.place,
				ownerUsername: params.user,
			}
		},
		select: {
			description: true,
			image: true,
		},
	})
	if (getPlace) {
		return {
			body: {
				place: {
					name: params.place,
					owner: params.user,
					img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
					description: getPlace.description,
					image: getPlace.image,
				},
			},
		}
	} else {
		return {
			status: 404,
			body: new Error(`Not found: /${params.place}`),
		}
	}
}
