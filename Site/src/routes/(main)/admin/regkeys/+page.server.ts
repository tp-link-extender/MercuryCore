import { error } from "@sveltejs/kit"
import { authorise } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { RequestEvent } from "./$types"
import regkeysQuery from "./regkeys.surql"

interface RegKey {
	created: string
	creator?: BasicUser
	expiry: Date | string | null
	id: string
	usesLeft: number
}

export async function load({ locals }: RequestEvent) {
	if (!config.Registration.Keys.Enabled) error(404, "Not Found")
	await authorise(locals, 5)

	const [regKeys] = await dbQuery<RegKey[][]>(regkeysQuery)
	return {
		prefix: config.Registration.Keys.Prefix,
		regKeys,
	}
}
