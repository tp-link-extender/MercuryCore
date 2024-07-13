import { getStipend } from "$lib/server/economy"
import { version } from "$lib/server/surreal"

export async function load() {
	return {
		database: await version(),
		stipend: await getStipend(),
	}
}
