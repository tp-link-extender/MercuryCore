import { redirect } from "@sveltejs/kit"
import { dev } from "$app/environment"

// Redirect to check page if in development mode
export async function load() {
	if (dev) redirect(302, "/check")
}
