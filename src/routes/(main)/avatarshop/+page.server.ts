import { findItems } from "$lib/server/prisma"

export const load = async () => ({
	items: findItems(),
})

export const actions = {
	default: async ({ request }) => {
		const filter = (await request.formData()).get("query") as string
		return {
			places: await findItems({
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
