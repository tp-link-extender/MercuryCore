import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export async function load({ locals }) {
	const { user } = await authorise(locals)

	const userExists = await prisma.authUser.findUnique({
		where: {
			number: user.number,
		},
	})
	if (!userExists) throw error(401)

	const query = {
		user: userExists.username,
	}

	return {
		users: prisma.authUser.findMany({
			where: {
				username: {
					in: (
						await roQuery(
							"friends",
							`
								MATCH (:User { name: $user }) <-[r:request]- (u:User)
								RETURN u.name AS name
							`,
							query,
							false,
							true
						)
					).map((i: any) => i.name),
				},
			},
			select: {
				username: true,
				number: true,
			},
		}),
		number: roQuery(
			"friends",
			"RETURN SIZE((:User { name: $user }) <-[:request]- (:User))",
			query,
			true
		),
	}
}
