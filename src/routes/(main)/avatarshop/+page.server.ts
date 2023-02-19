import type { PageServerLoad } from "./$types"
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
