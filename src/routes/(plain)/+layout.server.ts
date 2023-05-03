import { redirect } from "@sveltejs/kit"

// Redirect to homepage if user is logged in
export async function load({ locals }) {
	if (await locals.validate()) throw redirect(302, "/home")
}
