import { findPlaces } from "$lib/server/prisma"

export const load = async () => ({
	places: findPlaces({
		where: {
			privateServer: false,
		},
		include: {
			GameSessions: {
				where: {
					ping: {
						gt: Math.floor(Date.now() / 1000) - 35,
					},
				},
			},
		},
		orderBy: {
			serverPing: "desc",
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
			// When returning from an action, remember to only select
			// the data needed, as it will by sent directly to the client.
			select: {
				name: true,
				id: true,
				image: true,
				serverPing: true,
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
