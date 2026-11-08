import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
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
	const [logs] = await db.query<Log[][]>(logsQuery)
	return { logs }
}
