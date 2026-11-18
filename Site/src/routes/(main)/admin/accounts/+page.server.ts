import { authorise } from "#lib/server/auth.ts"
import { db } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import usersQuery from "./users.surql"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const [users] = await db.query<BasicUser[][]>(usersQuery)

	return {
		users,
	}
}
