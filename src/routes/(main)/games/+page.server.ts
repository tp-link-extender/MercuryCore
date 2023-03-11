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
			GameSessions: {
				where: {
					ping: {
						gt: Math.floor(Date.now() / 1000) - 35,
					},
				},
			},
		},
	}),
})

export const actions = {
	default: async ({ request }) => ({
		places: await findPlaces({
			where: {
				name: {
					contains: (await request.formData()).get("query") as string,
					mode: "insensitive",
				},
				privateServer: false,
			},
			select: {
				name: true,
				id: true,
				image: true,
				GameSessions: {
					where: {
						ping: {
							gt: Math.floor(Date.now() / 1000) - 35,
						},
					},
				},
			},
		}),
	}),
}
