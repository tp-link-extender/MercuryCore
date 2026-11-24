import { dbQuery } from "#lib/server/db/query.ts"
import { db, Record, type RecordId } from "#lib/server/surreal.ts"
import accessQuery from "./places/access.surql"
import createQuery from "./places/create.surql"
import flagsQuery from "./places/flags.surql"
import gamesQuery from "./places/games.surql"
import hostPlaceQuery from "./places/hostPlace.surql"
import hostPortQuery from "./places/hostPort.surql"
import idSummaryQuery from "./places/idSummary.surql"
import ownedPlacesQuery from "./places/owned.surql"
import pageQuery from "./places/page.surql"
import pingServerQuery from "./places/pingServer.surql"
import privacyQuery from "./places/privacy.surql"
import privateTicketQuery from "./places/privateTicket.surql"
import serverTicketQuery from "./places/serverTicket.surql"
import serveTicketQuery from "./places/serveTicket.surql"
import settingsQuery from "./places/settings.surql"
import startPlayingQuery from "./places/startPlaying.surql"
import updateSettingsQuery from "./places/updateSettings.surql"

export interface PlaceAccess {
	privateServer: boolean
	privateTicket: string
	serverTicket: string
}

export interface OwnedPlace {
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
}

/** A place as its page shows it, to the user who's looking at it. */
export interface PlacePage {
	clientVersion: number
	created: string
	description: string | null
	dislikeCount: number
	dislikes: boolean
	id: string
	likeCount: number
	likes: boolean
	maxPlayers: number
	name: string
	players: { status: "Playing"; username: string }[]
	privateServer: boolean
	privateTicket: string
	serverPing: number
	serverTicket: string
	updated: Date
}

/** A place as its settings page edits it. */
export interface PlaceSettings {
	clientVersion: number
	created: string
	dedicated: boolean
	description: string | null
	id: string
	maxPlayers: number
	name: string
	privateServer: boolean
	privateTicket: string
	serverAddress: string
	serverPing: number
	serverPort: number
	serverTicket: string
	updated: Date
}

/** A place as the game list shows it. */
export interface GamePlace {
	clientVersion: number
	dislikeCount: number
	id: number
	likeCount: number
	name: string
	playerCount: number
	serverPing: number
}

/**
 * Finds a place's name and whether it's private, which is all its URL needs.
 * @returns The place, or undefined if there is no such place.
 */
export async function placeSummaryOf(
	id: number
): Promise<{ name: string; privateServer: boolean } | undefined> {
	const [[place]] = await dbQuery<
		{ name: string; privateServer: boolean }[][]
	>(idSummaryQuery, { place: Record("place", id) })
	return place
}

/**
 * Finds the fields that decide whether a user may see a place, such as whether it's private.
 * @returns The fields, or undefined if there is no such place.
 */
export async function placeFlagsOf(id: number): Promise<
	| {
			clientVersion: number
			dedicated: boolean
			privateServer: boolean
			privateTicket: string
	  }
	| undefined
> {
	const [[place]] = await dbQuery<
		{
			clientVersion: number
			dedicated: boolean
			privateServer: boolean
			privateTicket: string
		}[][]
	>(flagsQuery, { place: Record("place", id) })
	return place
}

/**
 * Finds a place as a viewer may see it, with its players and likes.
 * @returns The place, or undefined if there is no such place.
 */
export async function placePageOf(
	id: number,
	viewer: RecordId<"user">
): Promise<PlacePage | undefined> {
	const [[place]] = await dbQuery<PlacePage[][]>(pageQuery, {
		place: Record("place", id),
		user: viewer,
	})
	return place
}

/**
 * Starts a play session for a user, which invalidates their other sessions.
 * @returns The ticket the client joins with.
 */
export async function startPlaying(
	place: RecordId<"place">,
	user: RecordId<"user">
): Promise<string | undefined> {
	const [, [ticket]] = await dbQuery<string[][]>(startPlayingQuery, {
		place,
		user,
	})
	return ticket
}

/** Finds the settings of a place. */
export async function placeSettingsOf(
	id: number
): Promise<PlaceSettings | undefined> {
	const [[place]] = await dbQuery<PlaceSettings[][]>(settingsQuery, {
		place: Record("place", id),
	})
	return place
}

export async function updatePlaceText(
	id: number,
	name: string,
	description: string
): Promise<void> {
	await dbQuery(updateSettingsQuery, {
		description,
		name,
		place: Record("place", id),
	})
}

/** Sets the network settings of a place. Only the fields given are changed. */
export async function updatePlaceNetwork(
	id: number,
	network: {
		clientVersion: number
		dedicated: boolean
		maxPlayers: number
		serverAddress?: string
		serverPort?: number
	}
): Promise<void> {
	await db.update(Record("place", id)).merge(network)
}

export async function setPlacePrivacy(
	id: number,
	privateServer: boolean
): Promise<void> {
	await dbQuery(privacyQuery, {
		place: Record("place", id),
		privateServer,
	})
}

/** Makes a new link to a private place, so the old one stops working. */
export async function regeneratePrivateTicket(id: number): Promise<void> {
	await dbQuery(privateTicketQuery, { place: Record("place", id) })
}

/** Makes a new server ticket, so the old one stops working. */
export async function regenerateServerTicket(id: number): Promise<void> {
	await dbQuery(serverTicketQuery, { place: Record("place", id) })
}

/**
 * Finds the games on a page of the game list, most players first.
 * @returns The places on the page, and how many pages there are.
 */
export async function gamesPage(
	page: number
): Promise<{ pages: number; places: GamePlace[] }> {
	const [places, pages] = await dbQuery<[GamePlace[], number]>(gamesQuery, {
		page,
	})
	return { pages, places }
}

/** Creates the record of a place, with the id the Economy service issued. */
export async function createPlaceRecord(place: {
	clientVersion: number
	description: string
	id: number
	maxPlayers: number
	name: string
	privateServer: boolean
	serverAddress: string
	serverPort: number
}): Promise<void> {
	await dbQuery(createQuery, place)
}

/**
 * Finds the id and port of the place hosted with this server ticket.
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

/**
 * Finds the places with these ids, with their players and likes.
 * @returns The places that exist.
 */
export async function ownedPlacesOf(ids: number[]): Promise<OwnedPlace[]> {
	const [places] = await dbQuery<OwnedPlace[][]>(ownedPlacesQuery, {
		ids: ids.map(id => Record("place", id)),
	})
	return places
}
