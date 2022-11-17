import { error } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export async function load({ params }: { params: any }) {
	const getUser = await prisma.user.findUnique({
		where: {
			username: params.user,
		},
		select: {
			displayname: true,
			bio: true,
			image: true,
			places: true,
		},
	})
	if (getUser) {
		return {
			username: params.user,
			displayname: getUser.displayname,
			img: getUser.image,
			bio: getUser.bio,
			places: getUser.places,
			followerCount: 420,
			friendCount: 21,
			friends: true,
			following: true,
			pendingRequest: false,
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}
