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
	console.time("user")
	params.user = params.user.toLowerCase()
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
		const session = await locals.validateUser()
		const client = createClient({ url: "redis://localhost:6479" })
		client.on("error", e => {
			console.log("Redis error", e)
			throw error(500, "Redis error")
		})
		await client.connect()

		const query = {
			params: {
				user1: session.user?.username || "",
				user2: params.user,
			},
		}
		const query2 = {
			params: {
				user: params.user,
			},
		}
		const graph = new Graph(client, "friends")

		console.timeEnd("user")

		// this is a stupid bug. previously just returning the result of a roQuery as "data" or whatever, then using .data, would break randomly
		const c = () => "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.random() * 52)
		const rand: any = Array(5).fill(0).map(c).join("")

		return {
			username: params.user,
			displayname: user.displayname,
			bio: user.bio,
			img: user.image,
			places: user.places,
			friendCount: (await roQuery(graph, `RETURN SIZE(() -[:friends]-> (:User { name: $user })) as ${rand}`, query2))[rand],
			followerCount: (await roQuery(graph, `RETURN SIZE(() -[:follows]-> (:User { name: $user })) as ${rand}`, query2))[rand],
			followingCount: (await roQuery(graph, `RETURN SIZE(() <-[:follows]- (:User { name: $user })) as ${rand}`, query2))[rand],
			friends: session ? roQuery(graph, "MATCH (:User { name: $user1 }) -[r:friends]- (:User { name: $user2 }) RETURN r", query) : false,
			following: session ? roQuery(graph, "MATCH (:User { name: $user1 }) -[r:follows]-> (:User { name: $user2 }) RETURN r", query) : false,
			follower: session ? roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:follows]- (:User { name: $user2 }) RETURN r", query) : false,
			incomingRequest: session ? roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query) : false,
			outgoingRequest: session ? roQuery(graph, "MATCH (:User { name: $user1 }) -[r:request]-> (:User { name: $user2 }) RETURN r", query) : false,
		}
	} else {
		throw error(404, `Not found: /${params.user}`)
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = data.get("action")?.toString() || ""

		const client = createClient({ url: "redis://localhost:6479" })
		client.on("error", e => {
			console.log("Redis error", e)
			throw error(500, "Redis error")
		})
		await client.connect()

		const user2 = await prisma.user.findUnique({
			where: {
				username: params.user,
			},
		})
		if (!user2) return fail(400, { msg: "User not found" })

		const query = {
			params: {
				user1: session.user.username,
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
					MATCH (u1:User { name: $user1 }) -[r:follows]-> (u2:User { name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "unfriend":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) -[r:friends]-> (u2:User { name: $user2 })
					MATCH (u1:User { name: $user1 }) <-[s:friends]- (u2:User { name: $user2 })
					DELETE r, s
					`,
					query
				)
				break
			case "request":
				if (!(await roQuery(graph, "MATCH (:User { name: $user1 }) -[r:friends]-> (:User { name: $user2 }) RETURN r", query))) {
					// Make sure users are not already friends
					if (await roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
						// If there is already an incoming request, accept it instead
						await graph.query(
							`
							MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
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
					MATCH (u1:User { name: $user1 }) -[r:request]-> (u2:User { name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "decline":
				await graph.query(
					`
					MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
					DELETE r
					`,
					query
				)
				break
			case "accept":
				if (await roQuery(graph, "MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
					// Make sure an incoming request exists before accepting
					await graph.query(
						`
						MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
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
