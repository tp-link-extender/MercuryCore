import { dbQuery } from "#lib/server/db/query.ts"
import listQuery from "./reports/list.surql"

export interface Report {
	category: string
	id: string
	note: string
	reportee: BasicUser
	reporter: BasicUser
	time: string
	url: string
}

/** Lists every report, newest first. */
export async function reportsOf(): Promise<Report[]> {
	const [reports] = await dbQuery<Report[][]>(listQuery)
	return reports
}
