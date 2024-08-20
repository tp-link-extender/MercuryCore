import { authorise } from "$lib/server/lucia"
import { equery, surql } from "$lib/server/surreal"

type Log = {
	action: "Account" | "Administration" | "Moderation" | "Economy"
	note: string
	time: Date
	user: BasicUser
}

export async function load({ locals }) {
	await authorise(locals, 5)

	const [logs] = await equery<Log[][]>(surql`
		SELECT
			*,
			meta::id(id) AS id,
			(SELECT status, username FROM user)[0] AS user
		FROM auditLog
		ORDER BY time DESC
	`)
	return { logs }
}
