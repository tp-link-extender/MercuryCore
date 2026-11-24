import config from "#lib/server/config.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { usesDedicated } from "#lib/server/dedicated.ts"
import idToPort, { proxyOffset } from "#lib/server/idToPort.ts"
import { Record } from "#lib/server/surreal.ts"
import joinQuery from "./join.surql"

interface ServerAddress {
	serverAddress: string
	serverPort: number
}

interface Session {
	place: {
		id: number
		dedicated: boolean
	} & ServerAddress
	user: {
		permissionLevel: number
		username: string
	}
}

function serverInfo(place: Session["place"]): ServerAddress {
	if (!usesDedicated(place.dedicated)) return place

	const url = new URL(config.Orbiter.PublicURL)
	return {
		serverAddress: url.hostname, // no scheme, the address doesn't usually have a path anyway
		serverPort: idToPort(place.id) + proxyOffset, // select the proxy port rather than the port of the server itself
	}
}

/** Claims a client ticket, which works once and only shortly after it's created, and returns the session with the address to connect to. Private places are checked when the ticket is created, so the ticket alone is enough here. */
export async function claimSession(
	clientTicket: string
): Promise<(Session & ServerAddress) | null> {
	const [, session] = await dbQuery<(Session | null)[]>(joinQuery, {
		playing: Record("playing", clientTicket),
	})
	if (!session) return null

	return { ...session, ...serverInfo(session.place) }
}
