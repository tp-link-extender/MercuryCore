import type { LayoutServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"

export const load: LayoutServerLoad = async ({ locals }) => {
	const session = await locals.validate()
	if (session) throw redirect(302, "/home")
}
