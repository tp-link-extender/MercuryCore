import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import type { PageServerLoadEvent } from "./$types"
import readAllQuery from "./readAll.surql"

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)

	await dbQuery(readAllQuery, {
		user: Record("user", user.id),
	})
}
