import type { PageServerLoad, Actions } from "./$types"
import { prisma } from "$lib/server/prisma"
import { Query, roQuery } from "$lib/server/redis"
import { error, fail, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals, params }) => {
	const session = await locals.validateUser()

	console.time("requests")

	const user = await prisma.user.findUnique({
		where: {
			id: session.user.userId,
		},
		select: {
			username: true,
			displayname: true,
			image: true,
		},
	})

	const query = {
		params: {
			user: user?.username,
		},
	}

	async function Users() {
		const usersQuery = await roQuery(
			`
			MATCH (:User { name: $user }) <-[r:request]- (u:User)
			RETURN u.name AS name
			`,
			query,
			false,
			true
		)

		let users: any[] = []

		for (let i of usersQuery || ([] as any)) {
			if (i.name)
				users.push(
					await prisma.user.findUnique({
						where: {
							username: i.name,
						},
						select: {
							id: true,
							username: true,
							displayname: true,
							image: true,
							status: true,
						},
					})
				)
		}

		return users
	}

	console.timeEnd("requests")
	return {
		users: Users(),
		number: roQuery("RETURN SIZE((:User { name: $user }) <-[:request]- (:User))", query, true),
	}
}

export const actions: Actions = {
	default: async ({ request, locals, params }) => {
		const session = await locals.validateUser()
		if (!session.session) throw redirect(302, "/login")

		const data = await request.formData()
		const action = (data.get("action")?.toString() || "").split(" ")

		const user2 = await prisma.user.findUnique({
			where: {
				username: action[1],
			},
		})
		if (!user2) return fail(400, { msg: "User not found" })

		const query = {
			params: {
				user1: session.user.username,
				user2: action[1],
			},
		}

		console.log("Action:", action)

		try {
			switch (action[0]) {
				case "decline":
					await Query(
						`
						MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
						DELETE r
						`,
						query
					)
					break
				case "accept":
					if (await roQuery("MATCH (:User { name: $user1 }) <-[r:request]- (:User { name: $user2 }) RETURN r", query))
						// Make sure an incoming request exists before accepting
						await Query(
							`
							MATCH (u1:User { name: $user1 }) <-[r:request]- (u2:User { name: $user2 })
							DELETE r
							MERGE (u1)
							MERGE (u2)
							MERGE (u1) <-[:friends]- (u2)
							`,
							query
							// The direction of the [:friends] relationship matches the direction of the previous [:request] relationship
						)
					else return fail(400)
					break
			}
		} catch (e) {
			console.error(e)
			throw error(500, "Redis error 2")
		}
	},
}
