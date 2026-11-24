import { dbQuery } from "#lib/server/db/query.ts"
import { Record } from "#lib/server/surreal.ts"
import accessQuery from "./places/access.surql"
import hostPlaceQuery from "./places/hostPlace.surql"
import hostPortQuery from "./places/hostPort.surql"
import pingServerQuery from "./places/pingServer.surql"
import serveTicketQuery from "./places/serveTicket.surql"

export interface PlaceAccess {
	privateServer: boolean
	privateTicket: string
	serverTicket: string
}

/**
 * Finds the port of the place hosted with this server ticket.
 * @returns The port, or undefined if no place has this ticket.
 */
export async function hostPort(ticket: string): Promise<number | undefined> {
	const [[place]] = await dbQuery<{ serverPort: number }[][]>(hostPortQuery, {
		ticket,
	})
	return place?.serverPort
}

/**
 * Finds the id and port of the place hosted with this server ticket.
 * @returns The place, or undefined if no place has this ticket.
 */
export async function hostPlace(
	ticket: string
): Promise<{ id: number; serverPort: number } | undefined> {
	const [[place]] = await dbQuery<{ id: number; serverPort: number }[][]>(
		hostPlaceQuery,
		{ ticket }
	)
	return place
}

/**
 * Finds the server ticket of a place, which its gameserver is started with.
 * @returns The server ticket, or undefined if there is no such place.
 */
export async function serveTicket(id: number): Promise<string | undefined> {
	const [[place]] = await dbQuery<{ serverTicket: string }[][]>(
		serveTicketQuery,
		{ place: Record("place", id) }
	)
	return place?.serverTicket
}

/**
 * Finds what decides who can download a place file.
 * @returns The access fields, or undefined if there is no such place.
 */
export async function placeAccess(
	id: number
): Promise<PlaceAccess | undefined> {
	const [[place]] = await dbQuery<PlaceAccess[][]>(accessQuery, {
		place: Record("place", id),
	})
	return place
}

/** Records that the gameserver with this ticket is still running. */
export async function pingServer(ticket: string): Promise<void> {
	await dbQuery(pingServerQuery, { ticket })
}
