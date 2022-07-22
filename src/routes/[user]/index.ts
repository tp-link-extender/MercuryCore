import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

/** @type {import("@sveltejs/kit").RequestHandler} */
export async function GET({ params }: { params: any }) {
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
			body: {
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
			},
		}
	} else {
		return {
			status: 404,
			body: new Error(`Not found: /${params.user}`),
		}
	}
}
