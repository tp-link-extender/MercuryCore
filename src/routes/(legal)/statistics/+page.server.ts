import type { PageServerLoad } from "./$types"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"

export const load: PageServerLoad = async () => ({
	users: prisma.user.count(),
	places: prisma.place.count(),
	groups: prisma.group.count(),
	items: prisma.item.count(),
	transactions: prisma.transaction.count(),
	friendships: roQuery("friends", "RETURN SIZE((:User) -[:friends]- (:User))", {}, true),
	currency: prisma.user.aggregate({
		_sum: {
			currency: true,
		},
		_avg: {
			currency: true,
		},
	}),
})
