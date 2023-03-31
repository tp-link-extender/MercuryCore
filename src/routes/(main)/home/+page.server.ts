import { authorise } from "$lib/server/lucia"
import { prisma, findPlaces } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import ratelimit from "$lib/server/ratelimit"
import formData from "$lib/server/formData"
import { fail } from "@sveltejs/kit"

export async function load({ locals }) {
	console.time("home")
	const { user } = await authorise(locals)
	// (main)/+layout.server.ts will handle most redirects for logged-out users,
	// but sometimes errors for this page.

	async function Friends() {
		const friendsQuery = await roQuery(
			"friends",
			`
				MATCH (:User { name: $user }) -[r:friends]- (u:User)
				RETURN u.name as name
			`,
			{
				user: user.username,
			},
			false,
			true
		)

		let friends: any[] = []

		for (let i of friendsQuery || ([] as any)) {
			if (i.name)
				friends.push(
					await prisma.authUser.findUnique({
						where: {
							username: i.name,
						},
						select: {
							username: true,
							image: true,
							number: true,
						},
					})
				)
		}

		return friends
	}

	console.timeEnd("home")
	return {
		places: findPlaces({
			where: {
				privateServer: false,
			},
			select: {
				name: true,
				image: true,
				id: true,
				GameSessions: {
					where: {
						ping: {
							gt: Math.floor(Date.now() / 1000) - 35,
						},
					},
				},
			},
		}),
		friends: Friends(),
		feed: prisma.post.findMany({
			select: {
				id: true,
				content: true,
				posted: true,
				authorUser: {
					select: {
						username: true,
						image: true,
						number: true,
					},
				},
			},
			orderBy: {
				posted: "desc",
			},
			take: 40,
		}),
	}
}

export const actions = {
	default: async ({ request, locals, getClientAddress }) => {
		const limit = ratelimit("statusPost", getClientAddress, 30)
		if (limit) return limit

		const { user } = await authorise(locals)

		const data = await formData(request)
		const status = data.status
		if (!status) return fail(400, { msg: "Invalid status" })

		await prisma.post.create({
			data: {
				authorUser: {
					connect: {
						username: user.username,
					},
				},
				content: status,
			},
		})
	},
}
