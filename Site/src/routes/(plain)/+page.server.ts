import { dev } from "$app/environment"
import { getStipend } from "$lib/server/economy"
import { version } from "$lib/server/surreal"
import { redirect } from "@sveltejs/kit"

export async function load() {
	if (!dev) redirect(302, "/login")
	return {
		database: await version(),
		stipend: await getStipend(),
	}
}
