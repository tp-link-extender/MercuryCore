import type { Actions, PageServerLoad } from "./$types"
import { fail, redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import { sanitize } from "isomorphic-dompurify"
import graph from "$lib/server/redis"

const prisma = new PrismaClient()
// TODO: replace this with a DB call, as this is global and will
// need to be filter by users of the friends.

const feedArray = [
	{
		text: "Welcome to Mercury!",
		date: new Date(),
		username: "builderman",
		displayname: "Builderman",
		image: "https://tr.rbxcdn.com/a2d3f7d8d3d915ca4fa6cfcd6427958d/150/150/AvatarHeadshot/Png",
	},
]

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const status = sanitize(data.get("status")?.toString() || "")
		if (status.length <= 0) return fail(400, { msg: "Invalid status" })

		feedArray.push({
			text: status, // normally would not be required, but SvelteMarkdown uses the unsafe @html tag, which would allow xss
			date: new Date(),
			username: session.user.username,
			displayname: session.user.displayname,
			image: session.user.image,
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
		feed: feedArray,
	}
}
