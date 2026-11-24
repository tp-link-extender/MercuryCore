import config from "#lib/server/config.ts"
import {
	claimPlayingSession,
	type PlayingSession,
} from "#lib/server/db/playing.ts"
import { usesDedicated } from "#lib/server/dedicated.ts"
import idToPort, { proxyOffset } from "#lib/server/idToPort.ts"

interface ServerAddress {
	serverAddress: string
	serverPort: number
}

function serverInfo(place: PlayingSession["place"]): ServerAddress {
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
): Promise<(PlayingSession & ServerAddress) | null> {
	const session = await claimPlayingSession(clientTicket)
	if (!session) return null

	return { ...session, ...serverInfo(session.place) }
}
