import { prisma } from "$lib/server/prisma"

export const load = () => ({
	assets: prisma.asset.findMany({
		select: {
			name: true,
			price: true,
			id: true,
		},
	}),
})

export const actions = {
	default: async ({ request }) => {
		const filter = (await request.formData()).get("query") as string
		return {
			places: await prisma.asset.findMany({
				where: {
					name: {
						contains: filter,
						mode: "insensitive",
					},
				},
				// When returning from an action, remember to only select
				// the data needed, as it will by sent directly to the client.
				select: {
					name: true,
					price: true,
					id: true,
				},
			}),
		}
	},
}
