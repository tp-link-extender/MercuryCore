import { findPlaces } from "$lib/server/prisma"

export const load = async () => ({
	places: findPlaces({
		where: {
			privateServer: false,
		},
		select: {
			name: true,
			id: true,
			image: true,
		},
	}),
})

export const actions = {
	default: async ({ request }) => {
		const filter = (await request.formData()).get("query") as string
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
					image: true,
				},
			}),
		}
	},
}
