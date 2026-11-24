import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { PageServerLoadEvent } from "./$types"
import reportsQuery from "./reports.surql"

interface Report {
	category: string
	id: string
	note: string
	reportee: BasicUser
	reporter: BasicUser
	time: string
	url: string
}

export async function load({ locals }: PageServerLoadEvent) {
	await authorise(locals, 5)

	const [reports] = await dbQuery<Report[][]>(reportsQuery)
	return { reports }
}
