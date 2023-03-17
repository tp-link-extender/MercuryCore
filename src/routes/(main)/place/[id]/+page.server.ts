import { authoriseUser } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export async function load({ locals, params }) {
	if (!params.id || !/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)

	const place = await prisma.place.findUnique({
		where: {
			id: parseInt(params.id),
		},
		select: {
			name: true,
			privateServer: true,
			ownerUser: {
				select: {
					id: true,
				},
			},
		},
	})

	if (!place) throw error(404, "Not found")
	if (
		!place.privateServer ||
		(await authoriseUser(locals.validateUser)).user.userId ==
			place.ownerUser?.id
	)
		throw redirect(302, `/place/${params.id}/${place.name}`)

	throw error(404, "Not found")
}
