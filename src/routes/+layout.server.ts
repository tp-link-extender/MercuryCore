import surql from "$lib/surrealtag"
import { prisma } from "$lib/server/prisma"
import { squery } from "$lib/server/surreal"
import { addUserData } from "$lib/server/lucia"

export async function load({ request, locals }) {
	const session = await locals.auth.validate(),
		user = session?.user
	// Not authorise function, as we don't want
	// to redirect to login page if not logged in

	let notifications
	if (session && user) {
		const notifications1 = (await squery(
			surql`
				SELECT
					*,
					(SELECT
						number,
						username
					FROM <-user)[0] AS sender
				FROM notification
				WHERE out = $user`,
			{
				user: `user:${user.id}`,
			},
		)) as {
			id: string
			in: string
			note: string
			out: string
			read: boolean
			relativeId: string
			sender: {
				number: number
				username: string
			}
			time: string
			type: string
		}[]

		console.log(user.id)

		// Make type relativeId optional so we can delete it later
		type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
		// i told myself i would never write types like this
		const notifications2: (Optional<
			(typeof notifications1)[0],
			"relativeId"
		> & { link?: string })[] = notifications1

		for (const i of notifications2) {
			console.log(i.type, i.relativeId)
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

					i.link = `/avatarshop/${comment.parentAsset.id}/${comment.parentAsset.id}/${comment.id}`
					break

				case "ForumPostReply":
				case "ForumReplyReply":
					const reply = (
						(await squery(
							surql`
							SELECT
								string::split(type::string(id), ":")[1] AS id,
								(SELECT
									string::split(type::string(id), ":")[1] AS id,
									(->in->forumCategory)[0].name as categoryName
								FROM ->replyToPost[0]->forumPost)[0] AS parentPost
							FROM $reply`,
							{
								reply: `forumReply:${i.relativeId}`,
							},
						)) as {
							id: string
							parentPost: {
								categoryName: string
								id: string
							}
						}[]
					)[0]
					if (!reply) break

					i.link = `/forum/${reply.parentPost.categoryName.toLowerCase()}/${
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
		banners: squery(surql`
			SELECT
				body,
				bgColour,
				textLight,
				string::split(type::string(id), ":")[1] AS id
			OMIT deleted
			FROM banner
			WHERE deleted = false AND active = true`) as Promise<
			{
				bgColour: string
				body: string
				id: string
				textLight: boolean
			}[]
		>,
		user: user ? addUserData(user) : null,
		notifications: notifications || [],
		url: request.url,
	}
}
