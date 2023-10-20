import { authorise } from "$lib/server/lucia"

// Admin pages on the site require a user to have at least permissionLevel 3
export async function load({ locals }) {
	await authorise(locals, 3)
}
