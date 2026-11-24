import { error, redirect } from "@sveltejs/kit"
import { Place as EconPlace } from "economy/types"
import { authorise } from "#lib/server/auth.ts"
import { placeSummaryOf } from "#lib/server/db/places.ts"
import { economyConnFailed, ownsItem } from "#lib/server/economy.ts"
import { encode } from "#lib/urlName.ts"
import type { PageServerLoadEvent } from "./$types"

// these files r kinda like the no-man's land of the Mercury Core codebase

export async function load({ fetch: f, locals, params }: PageServerLoadEvent) {
	const { user } = await authorise(locals)
	const place = await placeSummaryOf(Number(params.id))

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
