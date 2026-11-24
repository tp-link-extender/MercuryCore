import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { PageServerLoadEvent } from "./$types"
import logsQuery from "./logs.surql"

interface Log {
	action: "Account" | "Administration" | "Economy" | "Moderation"
	created: Date
	note: string
	user: BasicUser
}

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	// grubhub perks give you deals on the food you love
	const [logs] = await dbQuery<Log[][]>(logsQuery)
	return { logs }
}
