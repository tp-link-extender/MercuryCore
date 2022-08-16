import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").PageServerLoad} */
export async function load({ params }: { params: any }) {
	const getUser = await prisma.user.findUnique({
		where: {
			username: params.user,
		},
		select: {
			bio: true,
		},
	})
	if (getUser) {
		return {
			user: {
				name: params.user,
				img: "https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png",
				bio: getUser.bio,
				followerCount: 420,
				friendCount: 21,
				friends: true,
				following: true,
				pendingRequest: false,
			},
		}
	} else {
		throw new Error("@migration task: Migrate this return statement (https://github.com/sveltejs/kit/discussions/5774#discussioncomment-3292699)");
		return {
			status: 404,
			body: new Error(`Not found: /${params.user}`),
		}
	}
}
