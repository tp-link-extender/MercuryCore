import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export async function load({ params }: { params: any }) {
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
			place: {
				name: params.place,
				owner: params.user,
				img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
				description: getPlace.description,
				image: getPlace.image,
			},
		}
	} else {
		throw new Error("@migration task: Migrate this return statement (https://github.com/sveltejs/kit/discussions/5774#discussioncomment-3292699)");
		return {
			status: 404,
			body: new Error(`Not found: /${params.place}`),
		}
	}
}
