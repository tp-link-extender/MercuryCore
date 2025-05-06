import os from "node:os"
import { authorise } from "$lib/server/auth"

// Admin pages on the site require a user to have at least permissionLevel 3
// Remember to do this for every admin page: authentication is done at the hooks level, authorisation is not
export async function load({ locals }) {
	await authorise(locals, 3)

	return {
		freemem: os.freemem(), // because can't do os on clientside
		totalmem: os.totalmem(),
	}
}
