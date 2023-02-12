import type { PageServerLoad } from "./$types"
import { findItems } from "$lib/server/prisma"

export const load: PageServerLoad = async () => {
	return {
		items: findItems({
			select: {
				name: true,
				id: true,
			},
		}),
	}
}
