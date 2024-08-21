import { authorise } from "$lib/server/lucia"
import { equery, surql } from "$lib/server/surreal"

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

	const [reports] = await equery<Report[][]>(surql`
		SELECT
			category,
			note,
			time,
			url,
			meta::id(id) AS id,
			(SELECT status, username FROM ->user)[0] AS reportee,
			(SELECT status, username FROM <-user)[0] AS reporter
		FROM report
		ORDER BY time DESC
	`)
	return { reports }
}
