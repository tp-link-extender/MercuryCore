import type { LayoutServerLoad } from "./$types"
import { redirect } from "@sveltejs/kit"

<<<<<<< HEAD
export const load: PageServerLoad = async ({ locals, url: { pathname } }: { locals: any; url: any }) => {
=======
// Redirect to homepage if user is logged in
export const load: LayoutServerLoad = async ({ locals }) => {
>>>>>>> dev
	const session = await locals.validate()
	if (session) throw redirect(302, "/home")

	return { pathname }
}
