import type { PageServerLoad, Actions } from "./$types"
import { findItems } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	items: findItems({
		select: {
			name: true,
			price: true,
			id: true,
		},
	}),
})

export const actions: Actions = {
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
				select: {
					name: true,
					price: true,
					id: true,
				},
			}),
		}
	},
}
