import { redirect } from "@sveltejs/kit"
import { balance } from "economy/api"
import * as Econ from "economy/types"
import { dev } from "$app/environment"
import { version } from "$lib/server/surreal"

export async function load({ fetch: f }) {
	if (!dev) redirect(302, "/")

	// Probe the Economy service with a balance lookup for a user that won't exist in the ledger; this is only used to check connectivity. (Logged-in users can't reach this page, so we can't use a real user.)
	const economy = await balance(f, new Econ.User("probe"))

	return {
		database: (await version()).version,
		economyOk: economy.ok,
	}
}
