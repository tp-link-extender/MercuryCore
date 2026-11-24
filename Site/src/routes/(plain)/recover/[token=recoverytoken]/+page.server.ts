import { dbQuery } from "#lib/server/db/query.ts"
import { hashRecoveryToken } from "#lib/server/recoveryToken.ts"
import type { PageServerLoadEvent } from "./$types"
import checkQuery from "./check.surql"

// The token is in the URL, so keep it out of caches and Referer headers
const headers = Object.freeze({
	"Cache-Control": "no-store",
	"Referrer-Policy": "no-referrer",
})

// Only checks the token, without using it up, as email link scanners and previews will open the link before the user does
export async function load({ params, setHeaders }: PageServerLoadEvent) {
	setHeaders(headers)

	const [valid] = await dbQuery<boolean[]>(checkQuery, {
		hash: hashRecoveryToken(params.token),
	})

	return { token: params.token, valid }
}
