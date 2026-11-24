import {
	type Notification,
	notificationsOf,
} from "#lib/server/db/notifications.ts"
import { Record } from "#lib/server/surreal.ts"

export default async function getNotifications(user: SessionUser | null) {
	if (!user) return []
	const notifications = await notificationsOf(Record("user", user.id))

	for (const i of notifications)
		switch (i.type) {
			case "Follower":
			case "FriendRequest":
			case "NewFriend":
				i.link = `/user/${i.sender.username}`
				break
			case "AssetComment":
			case "CommentReply":
				// case "ForumMention":
				if (!i.relativeId) break

				i.link = `/comment/${i.relativeId}`
				break
			// case "AssetApproved":
			case "ItemPurchase":
				i.link = `/catalog/${i.relativeId}`
				break
			default:
				i.link = ""
		}

	return notifications.map((n: Notification) => {
		n.relativeId = undefined
		return n
	})
}
