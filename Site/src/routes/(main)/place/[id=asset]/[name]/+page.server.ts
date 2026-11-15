import { error, redirect } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "$lib/server/auth"
import config from "$lib/server/config"
import constantTimeEqual from "$lib/server/constantTimeEqual"
import {
	economyConnFailed,
	itemOwner,
	type OwnedUser,
} from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import { couldMatch, encode } from "$lib/urlName"
import type { PageServerLoadEvent } from "./$types"
import placeQuery from "./place.surql"

interface FoundPlace {
	clientVersion: number
	dedicated: boolean
	privateServer: boolean
	privateTicket: string
}

interface Place extends FoundPlace {
	clientVersion: number
	created: string
	description: string
	dislikeCount: number
	dislikes: boolean
	id: number
	likeCount: number
	likes: boolean
	maxPlayers: number
	name: string
	ownerUser: OwnedUser | null
	players: {
		status: "Playing"
		username: string
	}[]
	serverPing: number
	serverTicket: string
	updated: Date
}

const thumbnails = config.Images.DefaultPlaceThumbnails

/** Whether the ticket supplied by the client opens a private place. */
const ticketMatches = (supplied: unknown, place: FoundPlace): boolean =>
	typeof supplied === "string" &&
	supplied !== "" &&
	constantTimeEqual(supplied, place.privateTicket)

export async function load({
	fetch: f,
	locals,
	params,
	url,
}: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const privateTicket = url.searchParams.get("privateServer")
	const id = Number(params.id)
	const [[place]] = await db.query<Place[][]>(placeQuery, {
		place: Record("place", id),
		user: Record("user", user.id),
	})
	if (!place) error(404, "Place not found")

	const owner = await itemOwner(f, new EconPlace(id))
	if (!owner.ok) error(500, economyConnFailed)
	place.ownerUser = owner.value

	const isOwner = place.ownerUser?.id === user.id
	const hasTicket = ticketMatches(privateTicket, place)
	if (!isOwner && place.privateServer && !hasTicket)
		error(404, "Place not found")

	if (!isOwner && user.permissionLevel !== 5) place.serverTicket = ""
	// Non-owners only get back the ticket they came with, so seeing a place while it's public doesn't give access once it's private
	if (!isOwner)
		place.privateTicket =
			place.privateServer && hasTicket ? place.privateTicket : ""

	// ahh, reminds me of early Mercury 2
	const slug = encode(place.name)
	if (!couldMatch(place.name, params.name))
		redirect(302, `/place/${id}/${slug}`)

	// don't check gameserver status here or your mercury will slow to a crawl

	return {
		clientVersion: place.clientVersion,
		hosting: config.Gameservers.Hosting,
		orbiterURL: config.Orbiter.PublicURL,
		place,
		scheme: config.LauncherURI,
		slug,
		thumbnails: [id % thumbnails.length],
	}
}
