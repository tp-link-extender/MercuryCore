import { authorise } from "$lib/server/lucia"
import { squery, surql } from "$lib/server/surreal"
import { error, redirect } from "@sveltejs/kit"

export async function load({ locals, params }) {
	if (!params.id || !/^\d+$/.test(params.id))
		error(400, `Invalid place id: ${params.id}`)

	const place = await squery<{
		id: string
		name: string
		owner: {
			id: string
		}
		privateServer: boolean
	}>(
		surql`
			SELECT
				name,
				privateServer,
				meta::id(id) AS id,
				(SELECT meta::id(id) AS id
				FROM <-owns<-user)[0] AS owner
			FROM $place`,
		{ place: `place:${params.id}` }
	)

	if (
		place &&
		(!place.privateServer ||
			(await authorise(locals)).user.id === place.owner.id)
	)
		redirect(302, `/place/${params.id}/${place.name}`)

	error(404, "Place not found")
}
