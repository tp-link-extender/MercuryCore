import { error, redirect } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { Record } from "#lib/server/surreal.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"
import placeIdQuery from "./placeId.surql"

// these files r kinda like the no-man's land of the Mercury Core codebase

interface Place {
	name: string
	privateServer: boolean
}

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const [[place]] = await dbQuery<Place[][]>(placeIdQuery, {
		place: Record("place", Number(params.id)),
	})

	if (place) {
		const owns = await ownsItem(
			f,
			user.id,
			new EconPlace(Number(params.id))
		)
		if (!owns.ok) error(500, economyConnFailed)

		if (!place.privateServer || owns.value)
			redirect(302, `/place/${params.id}/${encode(place.name)}`)
	}

	error(404, "Place not found")
}
