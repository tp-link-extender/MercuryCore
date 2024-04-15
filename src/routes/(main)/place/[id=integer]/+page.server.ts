import { authorise } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import { encode } from "$lib/urlName"
import { error, redirect } from "@sveltejs/kit"

type Place = {
	id: string
	name: string
	owner: {
		id: string
	}
	privateServer: boolean
}

export async function load({ locals, params }) {
	const place = await squery<Place>(import("./placeId.surql"), {
		place: `place:${params.id}`,
	})

	if (
		place &&
		(!place.privateServer ||
			(await authorise(locals)).user.id === place.owner.id)
	)
		redirect(302, `/place/${params.id}/${encode(place.name)}`)

	error(404, "Place not found")
}
