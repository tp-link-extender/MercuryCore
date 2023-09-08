// The following and members pages for a group.

import cql from "$lib/cyphertag"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

export const load = async ({ params }) => {
	const group = await prisma.group.findUnique({
		where: {
			name: params.name,
		},
	})

	if (group) {
		const query = {
			group: params.name,
		}

		return {
			name: group.name,
			users: prisma.authUser.findMany({
				where: {
					username: {
						in: (
							await roQuery(
								"groups",
								cql`
									MATCH (u:User) -[r:in]-> (:Group { name: $group })
									RETURN u.name AS name`,
								query,
								false,
								true,
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
				"groups",
				cql`RETURN SIZE((:User) -[:in]-> (:Group { name: $group }))`,
				query,
				true,
			),
		}
	}

	throw error(404, "Not found")
}
