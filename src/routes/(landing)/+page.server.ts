import type { PageServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ locals }) => {
	const session = await locals.getSession()
	if (session) throw redirect(302, "/home")
}
