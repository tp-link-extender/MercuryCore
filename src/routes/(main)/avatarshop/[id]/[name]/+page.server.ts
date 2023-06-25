import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { error } from "@sveltejs/kit"

export async function load({ locals, params }) {
	if (!/^\d+$/.test(params.id))
		throw error(400, `Invalid place id: ${params.id}`)
	const id = parseInt(params.id)

	const getAsset = await prisma.asset.findUnique({
		where: { id },
		select: {
			id: true,
			name: true,
			price: true,
			description: true,
			type: true,

			creatorUser: {
				select: {
					username: true,
					number: true,
				},
			},
			owners: {
				select: {
					username: true,
					number: true,
				},
			},
			_count: {
				select: {
					owners: true,
				},
			},
		},
	})

	if (!getAsset) throw error(404, "Not found")

	const { user } = await authorise(locals)

	const assetOwned = await prisma.asset.findUnique({
		where: { id },
		select: {
			owners: {
				where: {
					id: user.id,
				},
			},
		},
	})

	return {
		...getAsset,
		owned: (assetOwned?.owners || []).length > 0,
		sold: getAsset._count.owners,
	}
}
