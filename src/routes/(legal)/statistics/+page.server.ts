import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"

export const load = () => ({
	users: prisma.authUser.count(),
	places: prisma.place.count(),
	groups: prisma.group.count(),
	items: prisma.item.count(),
	transactions: prisma.transaction.count(),
	friendships: roQuery(
		"friends",
		"RETURN SIZE((:User) -[:friends]- (:User))",
		{},
		true
	),
	followerships: roQuery(
		"friends",
		"RETURN SIZE((:User) -[:follows]-> (:User))",
		{},
		true
	),
	statusPosts: prisma.post.count(),
	forumPosts: prisma.forumPost.count(),
	forumReplies: prisma.forumReply.count(),
	currency: prisma.authUser.aggregate({
		_sum: {
			currency: true,
		},
		_avg: {
			currency: true,
		},
	}),
})
