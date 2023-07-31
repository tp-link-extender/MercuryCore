import { prisma } from "$lib/server/prisma"

export async function load({ request, locals }) {
	const session = await locals.auth.validate()
	const user = session?.user
	// Not authorise function, as we don't want
	// to redirect to login page if not logged in

	let notifications
	if (session && user) {
		const notifications1 = await prisma.notification.findMany({
			take: 40,
			orderBy: {
				time: "desc",
			},
			where: {
				receiverId: user.id,
			},
			select: {
				id: true,
				read: true,
				type: true,
				note: true,
				time: true,
				relativeId: true,
				sender: {
					select: {
						number: true,
						username: true,
					},
				},
			},
		})

		// Make type relativeId optional so we can delete it later
		type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
		// i told myself i would never write types like this
		const notifications2: (Optional<
			(typeof notifications1)[0],
			"relativeId"
		> & { link?: string })[] = notifications1

		for (const i of notifications2) {
			switch (i.type) {
				case "AssetApproved":
				case "FriendRequest":
				case "Follower":
				case "NewFriend":
					i.link = `/user/${i.sender.number}`
					break

				case "AssetComment":
				case "AssetCommentReply":
					const comment = await prisma.assetComment.findUnique({
						where: {
							id: i.relativeId,
						},
						include: {
							parentAsset: true,
						},
					})
					if (!comment) break

					i.link = "https://youtube.com/watch?v=Dx5i1t0mN78" // TODO
					// `/avatarshop/${comment.parentAsset.id}/${
					// 	comment.parentAsset.id
					// }/${comment.id}`
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
					}/${reply.id}`
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
					i.link = `/avatarshop/item/${i.relativeId}`
					break
				case "Message":
			}
			delete i.relativeId
		}
		notifications = notifications2
	}

	return {
		banners: prisma.announcements.findMany({
			where: {
				active: true,
			},
			select: {
				id: true,
				body: true,
				bgColour: true,
				textLight: true,
			},
		}),
		user,
		notifications: notifications || [],
		url: request.url,
	}
}
