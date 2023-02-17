import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"

export const load: PageServerLoad = async () => {
	return {
		users: prisma.user.count(),
		places: prisma.place.count(),
		groups: prisma.group.count(),
		items: prisma.item.count(),
		transactions: prisma.transaction.count(),
		friendships: roQuery("RETURN SIZE((:User) -[:friends]- (:User))", {}, true),
		currency: prisma.user.aggregate({
			_sum: {
				currency: true,
			},
			_avg: {
				currency: true,
			},
		}),
	}
}
