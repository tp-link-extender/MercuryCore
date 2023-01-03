import type { Actions, PageServerLoad } from "./$types"
import { error, fail } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
const prisma = new PrismaClient()

export const load: PageServerLoad = async ({ locals, params }) => {
	const session = await locals.getSession()
	const user = await prisma.user.findUnique({
		where: {
			username: params.user,
		},
		select: {
			displayname: true,
			bio: true,
			image: true,
			places: true,
			friends: {
				where: {
					id: session?.userId,
				},
			},
		},
	})
	if (user) {
		return {
			username: params.user,
			displayname: user.displayname,
			img: user.image,
			bio: user.bio,
			places: user.places,
			followerCount: 420,
			friendCount: 21,
			friends: user.friends[0],
			following: false,
			incomingRequest: false,
			outgoingRequest: false,
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		// More complex because idempotency
		const session = await locals.getSession()
		if (!session) throw fail(400)

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const user: any = await prisma.user.findUnique({
			where: {
				id: session.userId,
			},
			select: {
				friends: {
					select: {
						username: true,
					},
					where: {
						username: params.user,
					},
				},
				incomingRequests: {
					select: {
						username: true,
					},
					where: {
						username: params.user,
					},
				},
				outgoingRequests: {
					select: {
						username: true,
					},
					where: {
						username: params.user,
					},
				},
				following: {
					select: {
						username: true,
					},
					where: {
						username: params.user,
					},
				},
			},
		})

		if (user) {
			let update1 = {}
			let update2 = {}
			const user1 = await prisma.user.findUnique({
				where: {
					id: session.userId,
				},
			})
			const user2 = await prisma.user.findUnique({
				where: {
					username: params.user,
				},
			})

			switch (action) {
				case "friend":
					if (user.friends.length == 0) {
						return "friend"
					}
				case "unfriend":
					if (user.friends[0]) {
						return "unfriend"
					}

				case "accept":
					if (user.incomingRequests[0]) {
						update1 = {
							friends: {
								push: user2,
							},
							incomingRequests: {
								delete: {
									where: {
										username: user2?.username,
									},
								},
							},
						}
						update2 = {
							friends: {
								push: user1,
							},
							outgoingRequests: {
								delete: {
									where: {
										username: user1?.username,
									},
								},
							},
						}
						return "accept"
					}
				case "cancel":
					if (user.incomingRequests[0]) {
						return "cancel"
					}

				case "follow":
					if (user.following.length == 0) {
						return "follow"
					}
				case "unfollow":
					if (user.following[0]) {
						return "unfollow"
					}
			}

			await prisma.user.update({
				where: {
					id: session.userId,
				},
				data: update1,
			})
			await prisma.user.update({
				where: {
					username: params.user,
				},
				data: update2,
			})
		}
	},
}
