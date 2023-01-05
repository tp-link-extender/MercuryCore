import type { Actions, PageServerLoad } from "./$types"
import { error, fail, redirect } from "@sveltejs/kit"
import { PrismaClient } from "@prisma/client"
import { createClient, Graph } from "redis"
const prisma = new PrismaClient()

async function roQuery(graph: any, str: string, query: any) {
	try {
		return ((await graph.roQuery(str, query)).data || [])[0]
	} catch {
		return false
	}
}

export const load: PageServerLoad = async ({ locals, params }) => {
	const user = await prisma.user.findUnique({
		where: {
			username: params.user,
		},
		select: {
			displayname: true,
			bio: true,
			image: true,
			places: true,
		},
	})
	if (user) {
		const session = await locals.validate()
		const url = import.meta.env.REDIS_URL
		const client = url ? createClient({ url: import.meta.env.REDIS_URL }) : createClient()
		client.on("error", () => {
			throw error(500, "Redis error")
		})
		await client.connect()

		let user1
		if (session)
			user1 = await prisma.user.findUnique({
				where: {
					id: session.userId,
				},
				select: {
					username: true,
				},
			})
		const query = {
			params: {
				user1: user1?.username || "",
				user2: params.user,
			},
		}
		const graph = new Graph(client, "friends")

		return {
			username: params.user,
			displayname: user.displayname,
			img: user.image,
			bio: user.bio,
			places: user.places,
			followerCount: 420,
			friendCount: 21,
			friends: session ? await roQuery(graph, "MATCH (:User { name: $user1 }) -[r:friends]-> (:User{ name: $user2 }) RETURN r", query) : false,
			following: session ? await roQuery(graph, "MATCH (:User { name: $user1 }) -[r:follows]-> (:User{ name: $user2 }) RETURN r", query) : false,
			incomingRequest: session ? await roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User{ name: $user2 }) RETURN r", query) : false,
			outgoingRequest: session ? await roQuery(graph, "MATCH (:User { name: $user1 }) -[r:request]-> (:User{ name: $user2 }) RETURN r", query) : false,
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		// More complex because idempotency
		const session = await locals.validate()
		if (!session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const client = createClient({ url: import.meta.env.REDIS_URL })
		client.on("error", () => {
			throw error(500, "Redis error")
		})
		await client.connect()

		const user1 = await prisma.user.findUnique({
			where: {
				id: session.userId,
			},
			select: {
				username: true,
			},
		})
		const user2 = await prisma.user.findUnique({
			where: {
				username: params.user,
			},
		})
		if (!user1 || !user2) return fail(400)

		const query = {
			params: {
				user1: user1.username,
				user2: params.user,
			},
		}
		const graph = new Graph(client, "friends")

		console.log(action)

		switch (action) {
			case "follow":
				await graph.query(
					`
					MERGE (u1:User { name: $user1 })
					MERGE (u2:User { name: $user2 })
					MERGE (u1) -[:follows]-> (u2)
					`,
					query
				)
				break
			case "unfollow":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) -[r:follows]-> (u2:User{ name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "unfriend":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) -[r:friends]-> (u2:User{ name: $user2 })
					MATCH (u1:User { name: $user1 }) <-[s:friends]- (u2:User{ name: $user2 })
					DELETE r, s
					`,
					query
				)
				break
			case "request":
				if (!(await roQuery(graph, "MATCH (:User { name: $user1 }) -[r:friends]-> (:User{ name: $user2 }) RETURN r", query))) {
					// Make sure users are not already friends
					if (await roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User{ name: $user2 }) RETURN r", query))
						// If there is already an incoming request, accept it instead
						await graph.query(
							`
							MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User{ name: $user2 })
							DELETE r
							MERGE (u1)
							MERGE (u2)
							MERGE (u1) -[:friends]-> (u2)
							MERGE (u1) <-[:friends]- (u2)
							`,
							query
						)
					else
						await graph.query(
							`
						MERGE (u1:User { name: $user1 })
						MERGE (u2:User { name: $user2 })
						MERGE (u1) -[:request]-> (u2)
						`,
							query
						)
				} else return fail(400)
				break
			case "cancel":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) -[r:request]-> (u2:User{ name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "decline":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User{ name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "accept":
				if (await roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User{ name: $user2 }) RETURN r", query))
					// Make sure an incoming request exists before accepting
					await graph.query(
						`
						MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User{ name: $user2 })
						DELETE r
						MERGE (u1)
						MERGE (u2)
						MERGE (u1) -[:friends]-> (u2)
						MERGE (u1) <-[:friends]- (u2)
						`,
						query
					)
				else return fail(400)
				break
		}
	},
}
