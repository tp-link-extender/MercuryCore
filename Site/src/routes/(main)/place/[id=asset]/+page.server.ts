import { error, redirect } from "@sveltejs/kit"
import * as Econ from "economy/types"
import { authorise } from "$lib/server/auth"
import { economyConnFailed, ownsItem } from "$lib/server/economy"
import { db, Record } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import placeIdQuery from "./placeId.surql"

// these files r kinda like the no-man's land of the Mercury Core codebase

type Place = {
	name: string
	privateServer: boolean
}

export async function load({ fetch: f, locals, params }) {
	const { user } = await authorise(locals)
	const [[place]] = await db.query<Place[][]>(placeIdQuery, {
		place: Record("place", +params.id),
	})

	if (place) {
		const owns = await ownsItem(f, user.id, new Econ.Place(+params.id))
		if (!owns.ok) error(500, economyConnFailed)

		if (!place.privateServer || owns.value)
			redirect(302, `/place/${params.id}/${encode(place.name)}`)
	}

	error(404, "Place not found")
}
