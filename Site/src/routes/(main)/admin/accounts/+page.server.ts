import { authorise } from "#lib/server/auth.ts"
import { unmoderatedUsers } from "#lib/server/db/accounts.ts"
import type { PageServerLoadEvent } from "./$types"

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const users = await unmoderatedUsers()

	return {
		users,
	}
}
