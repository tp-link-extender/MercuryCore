import { Record, db } from "$lib/server/surreal"
import getAssetCommentQuery from "./getAssetComment.surql"
import getForumPostQuery from "./getForumPost.surql"
import getForumReplyQuery from "./getForumReply.surql"
import notificationsQuery from "./notifications.surql"

type Notification = {
	id: string
	note: string
	read: boolean
	relativeId?: string
	sender: BasicUser
	time: string
	type: string
	link?: string
}

type AssetComment = {
	id: string
	parentAsset: {
		id: string
		name: string
	}
}

async function getAssetComment(relativeId: string) {
	const [[result]] = await db.query<AssetComment[][]>(getAssetCommentQuery, {
		assetComment: Record("assetComment", relativeId),
	})
	return result
}

type ForumReply = {
	id: string
	parentPost: {
		categoryName: string
		id: string
	}
}

async function getForumReply(relativeId: string) {
	const [[result]] = await db.query<ForumReply[][]>(getForumReplyQuery, {
		forumReply: Record("forumReply", relativeId),
	})
	return result
}

type ForumPost = {
	category: {
		name: string
	}
}

async function getForumPost(relativeId: string) {
	const [[result]] = await db.query<ForumPost[][]>(getForumPostQuery, {
		forumPost: Record("forumPost", relativeId),
	})
	return result
}

export default async function (user: User | null) {
	if (!user) return []
	const [notifications] = await db.query<Notification[][]>(
		notificationsQuery,
		{ user: Record("user", user.id) }
	)

	for (const i of notifications)
		switch (i.type) {
			case "AssetApproved":
			case "FriendRequest":
			case "Follower":
			case "NewFriend":
				i.link = `/user/${i.sender.username}`
				break

			case "AssetComment":
			case "AssetCommentReply": {
				if (!i.relativeId) break
				const comment = await getAssetComment(i.relativeId)
				if (!comment) break

				i.link = `/catalog/${comment.parentAsset.id}/${comment.parentAsset.name}/${comment.id}`
				break
			}
			case "ForumPostReply":
			case "ForumReplyReply": {
				if (!i.relativeId) break
				const reply = await getForumReply(i.relativeId)
				if (!reply) break

				i.link = `/forum/${reply.parentPost.categoryName.toLowerCase()}/${
					reply.parentPost.id
				}/${reply.id}`
				break
			}
			case "ForumMention":
			case "ForumPost": {
				if (!i.relativeId) break
				const post = await getForumPost(i.relativeId)
				if (!post) break

				i.link = `/forum/${post.category.name.toLowerCase()}/${
					i.relativeId
				}`
				break
			}
			case "ItemPurchase":
				i.link = `/catalog/${i.relativeId}`
				break
			default:
				i.link = ""
		}

	return notifications.map(n => {
		n.relativeId = undefined
		return n
	})
}
