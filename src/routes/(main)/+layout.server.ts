import type { LayoutServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"

// Most pages on the site require a user to be logged in.
export const load: LayoutServerLoad = async ({ locals }) => {
	const session = await locals.validate()
	if (!session) throw redirect(302, "/login")
}
