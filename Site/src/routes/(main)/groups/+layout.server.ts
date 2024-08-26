import config from "$lib/server/config"
import { error } from "@sveltejs/kit"

export async function load() {
	if (!config.Pages.includes("Groups")) error(404, "Not Found")
}
