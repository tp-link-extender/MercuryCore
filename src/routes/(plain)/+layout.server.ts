import { redirect } from "@sveltejs/kit"

// Redirect to homepage if user is logged in
export async function load({ locals }) {
	if (await locals.auth.validate()) redirect(302, "/home")
}
