import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { PageServerLoadEvent } from "./$types"
import usersQuery from "./users.surql"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const [users] = await dbQuery<BasicUser[][]>(usersQuery)

	return {
		users,
	}
}
