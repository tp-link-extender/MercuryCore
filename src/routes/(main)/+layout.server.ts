import { authorise } from "$lib/server/lucia"

// Most pages on the site require a user to be logged in.
// No risk of data leakage to unauthenticated users here as a redirect is performed.
export async function load({ locals }) {
	await authorise(locals)
}
