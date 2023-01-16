import type { PageServerLoad } from "./$types"
import { error, redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import { createClient, Graph } from "redis"

const prisma = new PrismaClient()

export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.validateUser()
	if (!session.session) throw redirect(302, "/login")

	const client = createClient({ url: import.meta.env.REDIS_URL })

	client.on("error", e => {
		console.log(e)
		throw error(500, "Redis error")
	})
	await client.connect()
	const graph = new Graph(client, "friends")

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
						username: i?.name,
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

	const getPlaces = await prisma.place.findMany({
		select: {
			name: true,
			slug: true,
			image: true,
		},
	})
	return {
		places: getPlaces || [],
		friends: friends,
	}
}
