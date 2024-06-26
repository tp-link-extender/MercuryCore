import { authorise } from "$lib/server/lucia"
import { token } from "$lib/server/realtime"
import { Record, equery, surql } from "$lib/server/surreal"

// Most pages on the site require a user to be logged in.
// No risk of data leakage to unauthenticated users here as a redirect is performed.
export async function load({ locals }) {
	const { user } = await authorise(locals)

	// Generate a new realtime token if the current one has expired
	if (!user.realtimeExpiry || user.realtimeExpiry < Date.now() / 1000) {
		const { expiry, realtimeToken, realtimeHash } = token(user.id)
		user.realtimeExpiry = expiry
		user.realtimeToken = realtimeToken
		user.realtimeHash = realtimeHash

		await equery(
			surql`
				UPDATE $user MERGE {
					realtimeExpiry: $expiry,
					realtimeToken: $realtimeToken,
					realtimeHash: $realtimeHash
				}`,
			{
				expiry,
				realtimeToken,
				realtimeHash,
				user: Record("user", user.id),
			}
		)
	}

	return { user } // Always available, not User | null
}
