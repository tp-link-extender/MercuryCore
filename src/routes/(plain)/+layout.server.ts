import { redirect } from "@sveltejs/kit"

// Redirect to homepage if user is logged in
export async function load({ locals }) {
	const session = await locals.validate()
	if (session) throw redirect(302, "/home")
}
