import { authorise } from "$lib/server/auth"
import { Record, type RecordId, db } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import placeIdQuery from "./placeId.surql"

// these files r kinda like the no-man's land of the Mercury Core codebase

type Place = {
	name: string
	ownerId: RecordId<"user">
	privateServer: boolean
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const [[place]] = await db.query<Place[][]>(placeIdQuery, {
		place: Record("place", params.id),
	})

	if (place && (!place.privateServer || user.id === place.ownerId.id))
		redirect(302, `/place/${params.id}/${encode(place.name)}`)

	error(404, "Place not found")
}
