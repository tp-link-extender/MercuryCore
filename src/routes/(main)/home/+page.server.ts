import type { PageServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import graph from "$lib/server/redis"
import type { Actions } from "./$types"

const prisma = new PrismaClient()
// TODO: replace this with a DB call, as this is global and will
// need to be filter by users of the friends.
const feedArray = [
	{
		text: "Welcome To Mercury!",
		date: new Date(),
		user: "Builderman",
	},
]
export const actions: Actions = {
	default: async ({ request, locals }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const status = data.get("status")?.toString() || ""
		if (status.length <= 0) {
			return;
		} 
		feedArray.push({
			text: status,
			date: new Date(),
			user: session.user.username,
		})
	},
}
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
	async function Feed() {
		return feedArray
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
		feed: Feed(),
	}
}
