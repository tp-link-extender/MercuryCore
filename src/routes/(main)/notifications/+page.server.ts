import { authorise } from "$lib/server/lucia"
import { prisma } from "$lib/server/prisma"

export async function load({ locals }) {
	const notifications1 = await prisma.notification.findMany({
		take: 40,
		orderBy: {
			time: "desc",
		},
		where: {
			receiverId: (await authorise(locals.validateUser)).user.id,
		},
		include: {
			sender: true,
		},
	})

	const notifications: typeof notifications1 & { link?: string }[] =
		notifications1

	for (let i of notifications)
		switch (i.type) {
			case "AssetApproved":
			case "FriendRequest":
			case "Follower":
			case "NewFriend":
				i.link = `/user/${i.sender.username}`
				break

			case "ForumPostReply":
			case "ForumReplyReply":
				const reply = await prisma.forumReply.findUnique({
					where: {
						id: i.relativeId,
					},
					include: {
						parentPost: true,
					},
				})
				if (!reply) break

				i.link = `/forum/${reply.parentPost.forumCategoryName.toLowerCase()}/${
					reply.parentPost.id
				}/${reply.id}?depth=1`
				break

			case "ForumMention":
			case "ForumPost":
				const post = await prisma.forumPost.findUnique({
					where: {
						id: i.relativeId,
					},
				})
				if (!post) break

				i.link = `/forum/${post.forumCategoryName.toLowerCase()}/${
					post.id
				}`
				break

			case "ItemPurchase":
				i.link = `/item/${i.relativeId}`
				break
			case "Message":
		}

	return {
		notifications,
	}
}
