import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
import logsQuery from "./logs.surql"

type Log = {
	action: "Account" | "Administration" | "Moderation" | "Economy"
	note: string
	time: Date
	user: BasicUser
}

export async function load({ locals }) {
	await authorise(locals, 5)

	const [logs] = await db.query<Log[][]>(logsQuery)
	return { logs }
}
