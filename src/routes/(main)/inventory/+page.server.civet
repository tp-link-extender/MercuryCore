import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export const load = async ({ locals }) => ({
	assets: await prisma.asset.findMany({
		where: {
			owners: {
				some: {
					number: (await authorise(locals)).user.number,
				},
			},
		},
		select: {
			name: true,
			price: true,
			id: true,
		},
	}),
})
