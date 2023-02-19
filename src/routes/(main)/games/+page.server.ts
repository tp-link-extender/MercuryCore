import type { PageServerLoad } from "./$types"
import { findPlaces } from "$lib/server/prisma"

export const load: PageServerLoad = async () => ({
	places: findPlaces({
		select: {
			name: true,
			slug: true,
			image: true,
		},
	}),
})
