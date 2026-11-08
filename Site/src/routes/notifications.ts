import { db, Record } from "$lib/server/surreal"
import notificationsQuery from "./notifications.surql"

interface Notification {
	created: Date
	id: string
	link?: string
	note: string
	read: boolean
	relativeId?: string
	sender: BasicUser
	type: string
}

export default async function getNotifications(user: User | null) {
	if (!user) return []
	const [notifications] = await db.query<Notification[][]>(
		notificationsQuery,
		{ user: Record("user", user.id) }
	)

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

	return notifications.map(n => {
		n.relativeId = undefined
		return n
	})
}
