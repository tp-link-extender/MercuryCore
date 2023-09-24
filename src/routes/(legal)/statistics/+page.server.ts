import surql from "$lib/surrealtag"
import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"

export async function load({ locals }) {
	await authorise(locals)

	return {
		users: prisma.authUser.count(),
		places: prisma.place.count(),
		groups: prisma.group.count(),
		assets: prisma.asset.count(),
		transactions: prisma.transaction.count(),
		friendships: squery(surql`count(SELECT * FROM friends)`),
		followerships: squery(surql`count(SELECT * FROM follows)`),
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
