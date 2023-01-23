import type { Actions, PageServerLoad } from "./$types"
import { fail, redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import { sanitize } from "isomorphic-dompurify"
import {roQuery} from "$lib/server/redis"

const prisma = new PrismaClient()
// TODO: replace this with a DB call, as this is global and will
// need to be filter by users of the friends.

export const load: PageServerLoad = async ({ locals }) => {
	console.time("home")
	const session = await locals.validateUser()
	if (!session.session) throw redirect(302, "/login")

	async function Friends() {
		const friendsQuery = await roQuery(
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
		feed: prisma.post.findMany({
			select: {
				author: {
					select: {
						username: true,
						displayname: true,
						image: true,
					},
				},
				posted: true,
				content: true,
			},
		}),
	}
}

export const actions: Actions = {
	default: async ({ request, locals }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const status = sanitize(data.get("status")?.toString() || "") // normally would not be required, but SvelteMarkdown uses the unsafe @html tag, which would allow xss
		if (status.length <= 0) return fail(400, { msg: "Invalid status" })

		await prisma.post.create({
			data: {
				author: {
					connect: {
						username: session.user.username,
					},
				},
				content: status,
			},
		})
	},
}
