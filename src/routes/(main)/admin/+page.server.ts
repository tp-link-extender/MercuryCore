import os from "os"
import { authorise } from "$lib/server/lucia"
import checkDiskSpace from "check-disk-space"

// Make sure a user is an administrator before loading the page.
export async function load({ locals }) {
	await authorise(locals, 3)

	return {
		freemem: os.freemem(), // because cant do os on clientside
		totalmem: os.totalmem(),
	}
}

export const actions = {
	default: async () =>
		// This function takes like 700ms to run, and
		// streaming promises still takes a good while
		{
			const { free, size } = await checkDiskSpace(os.homedir())
			return { free, size }
		},
}
