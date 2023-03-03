import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export const load: PageServerLoad = async ({ params }) => {
	if (!params.id || !/^\d+$/.test(params.id)) throw error(400, `Invalid place id: ${params.id}`)

	const place = await prisma.place.findUnique({
		where: {
			id: parseInt(params.id),
		},
		select: {
			name: true,
		},
	})

	if (place) throw redirect(302, `/place/${params.id}/${place.name}`)
	else throw error(404, "Not found")
}
