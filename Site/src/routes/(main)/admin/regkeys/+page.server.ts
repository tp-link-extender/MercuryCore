import { error } from "@sveltejs/kit"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import { db } from "$lib/server/surreal"
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

	const [regKeys] = await db.query<RegKey[][]>(regkeysQuery)
	return {
		prefix: config.Registration.Keys.Prefix,
		regKeys,
	}
}
