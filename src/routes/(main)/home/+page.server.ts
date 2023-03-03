import type { PageServerLoad, Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma, findPlaces } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { fail } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals }) => {
	console.time("home")
	const user = (await authoriseUser(locals.validateUser)).user
	// (main)/+layout.server.ts will handle most redirects for logged-out users,
	// but sometimes errors for this page.

	async function Friends() {
		const friendsQuery = await roQuery(
			`
				MATCH (:User { name: $user }) -[r:friends]- (u:User)
				RETURN u.name as name
			`,
			{
				params: {
					user: user?.username,
				},
			},
			false,
			true
		)

		let friends: any[] = []

		for (let i of friendsQuery || ([] as any)) {
			if (i.name)
				friends.push(
					await prisma.user.findUnique({
						where: {
							username: i.name,
						},
						select: {
							number: true,
							username: true,
							image: true,
							status: true,
						},
					})
				)
		}

		return friends
	}

	console.timeEnd("home")
	return {
		places: findPlaces({
			select: {
				name: true,
				id: true,
				image: true,
			},
		}),
		friends: Friends(),
		feed: prisma.post.findMany({
			select: {
				authorUser: {
					select: {
						number: true,
						username: true,
						image: true,
					},
				},
				posted: true,
				content: true,
			},
			orderBy: {
				posted: "desc",
			},
			take: 40,
		}),
	}
}

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const user = (await authoriseUser(locals.validateUser)).user

		const data = await request.formData()
		const status = data.get("status")?.toString() || ""
		if (status.length <= 0) return fail(400, { msg: "Invalid status" })

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
