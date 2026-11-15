import { authorise } from "$lib/server/auth"
import { db, Record } from "$lib/server/surreal"
import type { PageServerLoadEvent } from "./$types"
import readAllQuery from "./readAll.surql"

export async function load({ locals }: PageServerLoadEvent) {
	const { user } = await authorise(locals)

	await db.query(readAllQuery, {
		user: Record("user", user.id),
	})
}
