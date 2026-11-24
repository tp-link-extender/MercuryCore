import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import claimQuery from "./playing/claim.surql"
import pingQuery from "./playing/ping.surql"

export interface PlayingSession {
	place: {
		dedicated: boolean
		id: number
		serverAddress: string
		serverPort: number
	}
	user: {
		permissionLevel: number
		username: string
	}
}

/**
 * Claims a client ticket, which works once and only shortly after it's created.
 * @returns The session the ticket was made for, or null if it's invalid, used or expired.
 */
export async function claimPlayingSession(
	ticket: string
): Promise<PlayingSession | null> {
	const [, session] = await dbQuery<(PlayingSession | null)[]>(claimQuery, {
		playing: Record("playing", ticket),
	})
	return session
}

/** Records that the client with this ticket is still playing. */
export async function pingClient(ticket: string): Promise<void> {
	await dbQuery(pingQuery, { playing: Record("playing", ticket) })
}
