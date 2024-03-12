import { query, squery, surql } from "$lib/server/surreal"
import type { Session, User } from "lucia"

type Notification = {
	id: string
	in: string
	note: string
	out: string
	read: boolean
	relativeId?: string
	sender: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	time: string
	type: string
	link?: string
}

export default async function (session: Session | null, user: User | null) {
	if (!session || !user) return []
	const notifications = await query<Notification>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM <-user)[0] AS sender
			FROM notification
			WHERE out = $user
			ORDER BY time DESC`,
		{ user: `user:${user.id}` }
	)

	for (const i of notifications) {
		switch (i.type) {
			case "AssetApproved":
			case "FriendRequest":
			case "Follower":
			case "NewFriend":
				i.link = `/user/${i.sender.number}`
				break

			case "AssetComment":
			case "AssetCommentReply": {
				const comment = await squery<{
					id: string
					parentAsset: {
						id: string
						name: string
					}
				}>(
					surql`
						SELECT
							*,
							meta::id(id) AS id,
							(SELECT meta::id(id) AS id, name
							FROM ->replyToAsset->asset)[0] AS parentAsset
						FROM $comment`,
					{ comment: `assetComment:${i.relativeId}` }
				)
				if (!comment) break

				i.link = `/avatarshop/${comment.parentAsset.id}/${comment.parentAsset.name}/${comment.id}`
				break
			}
			case "ForumPostReply":
			case "ForumReplyReply": {
				const reply = await squery<{
					id: string
					parentPost: {
						categoryName: string
						id: string
					}
				}>(
					surql`
						SELECT
							meta::id(id) AS id,
							(SELECT
								meta::id(id) AS id,
								(->in->forumCategory)[0].name as categoryName
							FROM ->replyToPost[0]->forumPost)[0] AS parentPost
						FROM $reply`,
					{ reply: `forumReply:${i.relativeId}` }
				)
				if (!reply) break

				i.link = `/forum/${reply.parentPost.categoryName.toLowerCase()}/${
					reply.parentPost.id
				}/${reply.id}`
				break
			}
			case "ForumMention":
			case "ForumPost": {
				const post = await squery<{
					category: {
						name: string
					}
				}>(
					surql`
						SELECT
							(SELECT name
							FROM ->in->forumCategory) AS category
						FROM $forumPost`,
					{ forumPost: `forumPost:${i.relativeId}` }
				)
				if (!post) break

				i.link = `/forum/${post.category.name.toLowerCase()}/${
					i.relativeId
				}`
				break
			}
			case "ItemPurchase":
				i.link = `/avatarshop/${i.relativeId}`
		}
	}

	return notifications.map(n => {
		n.relativeId = undefined
		return n
	})
}
