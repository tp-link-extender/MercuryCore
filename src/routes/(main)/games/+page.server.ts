import type { PageServerLoad, Actions } from "./$types"
import { findPlaces } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	places: findPlaces({
		where: {
			privateServer: false	
		},
		select: {
			name: true,
			id: true,
			image: true,
		},
	}),
})

export const actions: Actions = {
	default: async ({ request }) => {
		const filter = (await request.formData()).get("query")?.toString()
		return {
			places: await findPlaces({
				where: {
					name: {
						contains: filter,
						mode: "insensitive",
					},
					privateServer: false,
				},
				select: {
					name: true,
					id: true,
					image: true
				},
			}),
		}
	},
}
