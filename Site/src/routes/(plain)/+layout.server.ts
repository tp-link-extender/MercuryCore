import { redirect } from "@sveltejs/kit"
import type { LayoutServerLoadEvent } from "./$types"

// Redirect to homepage if user is logged in
export function load({ locals }: LayoutServerLoadEvent) {
	if (locals.session) redirect(302, "/home")
}
