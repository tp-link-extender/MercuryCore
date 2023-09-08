import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { roQuery } from "$lib/server/redis"
import cql from "$lib/cyphertag"

export async function load({ locals }) {
	await authorise(locals)

	return {
		users: prisma.authUser.count(),
		places: prisma.place.count(),
		groups: prisma.group.count(),
		assets: prisma.asset.count(),
		transactions: prisma.transaction.count(),
		friendships: roQuery(
			"friends",
			cql`RETURN SIZE((:User) -[:friends]- (:User))`,
			{},
			true,
		),
		followerships: roQuery(
			"friends",
			cql`RETURN SIZE((:User) -[:follows]-> (:User))`,
			{},
			true,
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
	}
}
