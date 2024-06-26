import { Record, equery, surql } from "$lib/server/surreal"
import type { User } from "lucia"

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
	const [[result]] = await equery<AssetComment[][]>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT meta::id(id) AS id, name
				FROM ->replyToAsset->asset)[0] AS parentAsset
			FROM ${Record("assetComment", relativeId)}`
	)
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
	const [[result]] = await equery<ForumReply[][]>(
		surql`
			SELECT
				meta::id(id) AS id,
				(SELECT
					meta::id(id) AS id,
					(->in->forumCategory)[0].name as categoryName
				FROM ->replyToPost[0]->forumPost)[0] AS parentPost
			FROM ${Record("forumReply", relativeId)}`
	)
	return result
}

type ForumPost = { category: { name: string } }

async function getForumPost(relativeId: string) {
	const [[result]] = await equery<ForumPost[][]>(
		surql`
			SELECT
				(SELECT name
				FROM ->in->forumCategory) AS category
			FROM ${Record("forumPost", relativeId)}`
	)
	return result
}

export default async function (user: User | null) {
	if (!user) return []
	const [notifications] = await equery<Notification[][]>(
		surql`
			SELECT
				*,
				meta::id(id) AS id,
				(SELECT number, status, username
				FROM <-user)[0] AS sender
			OMIT in, out
			FROM notification
			WHERE out = ${Record("user", user.id)}
			ORDER BY time DESC`
	)

	for (const i of notifications)
		switch (i.type) {
			case "AssetApproved":
			case "FriendRequest":
			case "Follower":
			case "NewFriend":
				i.link = `/user/${i.sender.number}`
				break

			case "AssetComment":
			case "AssetCommentReply": {
				if (!i.relativeId) break
				const comment = await getAssetComment(i.relativeId)
				if (!comment) break

				i.link = `/avatarshop/${comment.parentAsset.id}/${comment.parentAsset.name}/${comment.id}`
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
				i.link = `/avatarshop/${i.relativeId}`
				break
			default:
				i.link = ""
		}

	return notifications.map(n => {
		n.relativeId = undefined
		return n
	})
}
