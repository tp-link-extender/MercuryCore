import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export async function load({ locals, params }) {
	if (!params.id || !/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)

	const place = await prisma.place.findUnique({
		where: {
			id: parseInt(params.id),
		},
		include: {
			ownerUser: true,
		},
	})

	if (!place) throw error(404, "Not found")
	if (
		!place.privateServer ||
		(await authorise(locals.validateUser)).user.id == place.ownerUser?.id
	)
		throw redirect(302, `/place/${params.id}/${place.name}`)

	throw error(404, "Not found")
}
