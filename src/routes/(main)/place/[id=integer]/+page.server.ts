import { authorise } from "$lib/server/lucia"
import { RecordId, equery } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"
import placeIdQuery from "./placeId.surql"

// these files r kinda like the no-man's land of the Mercury codebase

type Place = {
	id: string
	name: string
	owner: {
		id: string
	}
	privateServer: boolean
}

export async function load({ locals, params }) {
	const { user } = await authorise(locals)
	const [[place]] = await equery<Place[][]>(placeIdQuery, {
		place: new RecordId("place", params.id),
	})

	if (place && (!place.privateServer || user.id === place.owner.id))
		redirect(302, `/place/${params.id}/${encode(place.name)}`)

	error(404, "Place not found")
}
