import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { regKeysOf } from "#lib/server/db/regkeys.ts"
import type { RequestEvent } from "./$types"

export async function load({ locals }: RequestEvent) {
	if (!config.Registration.Keys.Enabled) error(404, "Not Found")
	await authorise(locals, 5)

	const regKeys = await regKeysOf()
	return {
		prefix: config.Registration.Keys.Prefix,
		regKeys,
	}
}
