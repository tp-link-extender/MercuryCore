import { authoriseAdmin } from "$lib/server/lucia"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAdmin(locals)
}
