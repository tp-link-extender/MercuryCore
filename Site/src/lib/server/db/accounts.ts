import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import profileQuery from "./accounts/profile.surql"

export interface Profile {
	description: string | null
	// masked, as only the domain of the address is shown
	email: string
}

/**
 * Finds the account details that only the settings page shows, which the session doesn't carry.
 * @returns The profile, or undefined if there is no such user.
 */
export async function profileOf(id: string): Promise<Profile | undefined> {
	const [profile] = await dbQuery<Profile[]>(profileQuery, {
		user: Record("user", id),
	})
	// FROM ONLY gives null for a missing user, which is returned as undefined
	return profile ?? undefined
}
