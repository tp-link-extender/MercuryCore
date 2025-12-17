import { redirect } from "@sveltejs/kit"
import { dev } from "$app/environment"
import { getStipend } from "$lib/server/economy"
import { version } from "$lib/server/surreal"

export async function load({ fetch: f }) {
	if (!dev) redirect(302, "/login")
	return {
		database: await version(),
		stipend: await getStipend(f),
	}
}
