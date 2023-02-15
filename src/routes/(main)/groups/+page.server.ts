import type { PageServerLoad } from "./$types"
import { findGroups } from "$lib/server/prisma"

export const load: PageServerLoad = async () => {
	return {
		groups: findGroups({
			select: {
				name: true,
			},
		}),
	}
}
