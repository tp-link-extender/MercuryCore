import os from "os"
import { authoriseAllAdmin } from "$lib/server/lucia"
import checkDiskSpace from "check-disk-space"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authoriseAllAdmin(locals)

	return {
		freemem: os.freemem(), // because cant do os on clientside
		totalmem: os.totalmem(),
		stream: { // This function takes like 700ms to run
			disk: checkDiskSpace(os.homedir()), // because top level await doesnt work in svelte
		}
	}
}
