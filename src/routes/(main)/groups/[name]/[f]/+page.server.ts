// The following and members pages for a group.

import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import { error } from "@sveltejs/kit"

const types = ["followers", "members"]

const usersQueries: any = {
	followers: `
		MATCH (:Group { name: $group }) <-[r:follows]- (u:User)
		RETURN u.name AS name`,
	members: `
		MATCH (:Group { name: $group }) <-[r:in]- (u:User)
		RETURN u.name AS name`,
}

const numberQueries: any = {
	followers: "RETURN SIZE((:Group { name: $group }) <-[:follows]- (:User))",
	members: "RETURN SIZE((:Group { name: $group }) <-[:in]- (:User))",
}

export const load: PageServerLoad = async ({ params }) => {
	if (params.f && !types.includes(params.f)) throw error(400, "Not found")
	const type = params.f
	console.time("group " + type)

	const group = await prisma.group.findUnique({
		where: {
			name: params.name,
		},
		select: {
			name: true,
		},
	})
	if (group) {
		const query = {
			params: {
				group: params.name,
			},
		}

		async function Users() {
			const usersQuery = await roQuery(usersQueries[type], query, false, true)

			let users: any[] = []

			for (let i of usersQuery || ([] as any)) {
				if (i.name)
					users.push(
						await prisma.user.findUnique({
							where: {
								username: i.name,
							},
							select: {
								number: true,
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

		console.timeEnd("group " + type)
		return {
			type,
			name: group.name,
			users: Users(),
			number: roQuery(numberQueries[type], query, true),
		}
	} else {
		throw error(404, `Not found`)
	}
}
