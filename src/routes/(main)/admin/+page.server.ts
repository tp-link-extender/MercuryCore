import os from "node:os"
import { authorise } from "$lib/server/lucia"
import checkDiskSpace from "check-disk-space"

// Admin pages on the site require a user to have at least permissionLevel 3
// Remember to do this for every admin page: authentication is done at the hooks level, authorisation is not
export async function load({ locals }) {
	await authorise(locals, 3)

	return {
		freemem: os.freemem(), // because can't do os on clientside
		totalmem: os.totalmem(),
	}
}

export const actions: import("./$types").Actions = {}
actions.default = async ({ locals }) => {
	await authorise(locals, 3)
	// This function takes like 700ms to run, and streaming promises still takes a good while
	const { free, size } = await checkDiskSpace(os.homedir())
	return { free, size }
}
