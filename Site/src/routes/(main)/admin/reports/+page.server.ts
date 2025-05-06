import { authorise } from "$lib/server/auth"
import { db } from "$lib/server/surreal"
import reportsQuery from "./reports.surql"

type Report = {
	category: string
	id: string
	note: string
	reportee: BasicUser
	reporter: BasicUser
	time: string
	url: string
}

export async function load({ locals }) {
	await authorise(locals, 5)

	const [reports] = await db.query<Report[][]>(reportsQuery)
	return { reports }
}
