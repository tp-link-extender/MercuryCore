import { error, redirect } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import config from "#lib/server/config.ts"
import constantTimeEqual from "#lib/server/constantTimeEqual.ts"
import { placePageOf } from "#lib/server/db/places.ts"
import { economyConnFailed, itemOwner } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import { couldMatch, encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"

const thumbnails = config.Images.DefaultPlaceThumbnails

/** Whether the ticket supplied by the client opens a private place. */
const ticketMatches = (
	supplied: unknown,
	place: { privateTicket: string }
): boolean =>
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
	const found = await placePageOf(id, Record("user", user.id))
	if (!found) error(404, "Place not found")

	const owner = await itemOwner(f, new EconPlace(id))
	if (!owner.ok) error(500, economyConnFailed)
	const place = { ...found, ownerUser: owner.value }

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
