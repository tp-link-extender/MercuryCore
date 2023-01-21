import type { PageServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import graph from "$lib/server/redis"

const prisma = new PrismaClient()

export const load: PageServerLoad = async ({ locals }) => {
	console.time("home")
	const session = await locals.validateUser()
	if (!session.session) throw redirect(302, "/login")

	async function Friends() {
		const friendsQuery = await graph.roQuery(
			`
			MATCH (:User { name: $user1 }) -[r:friends]-> (u:User)
			RETURN u.name as name
			`,
			{
				params: {
					user1: session.user.username,
				},
			}
		)

		let friends: any[] = []

		for (let i of friendsQuery.data || ([] as any)) {
			if (i.name)
				friends.push(
					await prisma.user.findUnique({
						where: {
							username: i.name,
						},
						select: {
							username: true,
							displayname: true,
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
		places: prisma.place.findMany({
			select: {
				name: true,
				slug: true,
				image: true,
			},
		}),
		friends: Friends(),
	}
}
