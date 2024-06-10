import { authorise } from "$lib/server/lucia"
import { equery } from "$lib/server/surreal"
import statisticsQuery from "./statistics.surql"

export async function load({ locals }) {
	await authorise(locals)

	return { stats: await equery<number[]>(statisticsQuery) }
}
