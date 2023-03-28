import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	console.time("requests")

	const userExists = await prisma.user.findUnique({
		where: {
			number: user.number,
		},
	})
	if (!userExists) throw error(401)

	const query = {
		user: userExists.username,
	}

	async function Users() {
		const usersQuery = await roQuery(
			"friends",
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
							username: true,
							number: true,
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
		number: roQuery(
			"friends",
			"RETURN SIZE((:User { name: $user }) <-[:request]- (:User))",
			query,
			true
		),
	}
}
