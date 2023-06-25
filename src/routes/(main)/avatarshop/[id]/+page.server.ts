import { prisma } from "$lib/server/prisma"
import { error, redirect } from "@sveltejs/kit"

export async function load({ params }) {
	if (!params.id || !/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)

	const asset = await prisma.asset.findUnique({
		where: {
			id: parseInt(params.id),
		},
	})

	if (!asset) throw error(404, "Not found")

	throw redirect(302, `/avatarshop/${params.id}/${asset.name}`)
}
