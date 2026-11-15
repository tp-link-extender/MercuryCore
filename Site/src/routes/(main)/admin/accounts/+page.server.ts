import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import usersQuery from "./users.surql"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 4)

	const [users] = await db.query<BasicUser[][]>(usersQuery)

	return {
		users,
	}
}
