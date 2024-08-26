import config from "$lib/server/config.js"
import { authorise } from "$lib/server/lucia"
import { equery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"
import statisticsQuery from "./statistics.surql"

export async function load({ locals }) {
	if (!config.Pages.includes("Statistics")) error(404, "Not Found")
	await authorise(locals)

	return { stats: await equery<number[]>(statisticsQuery) }
}
