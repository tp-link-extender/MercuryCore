import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import listQuery from "./notifications/list.surql"
import notifyQuery from "./notifications/notify.surql"
import readQuery from "./notifications/read.surql"
import readAllQuery from "./notifications/readAll.surql"

export interface Notification {
	id: string
	// set by the route from the type, and read by the client
	link?: string
	note: string
	read: boolean
	relativeId?: string
	sender: BasicUser
	type: string
}

/**
 * Lists a user's notifications, newest first.
 * @returns The notifications, without links, which the route adds.
 */
export async function notificationsOf(
	user: RecordId<"user">
): Promise<Notification[]> {
	const [notifications] = await dbQuery<Notification[][]>(listQuery, { user })
	return notifications
}

/**
 * Sends a notification from one user to another.
 * @param type The kind of notification, such as "Follower" or "AssetComment", which decides its link.
 * @param relativeId The id of what the notification is about.
 */
export async function notify(
	sender: RecordId<"user">,
	receiver: RecordId<"user">,
	type: string,
	note: string,
	relativeId: string
): Promise<void> {
	await dbQuery(notifyQuery, { note, receiver, relativeId, sender, type })
}

/**
 * Marks one of a user's notifications as read.
 * @returns The updated notifications, which is empty if the user doesn't have this one.
 */
export async function markNotificationRead(
	id: string,
	user: RecordId<"user">
): Promise<unknown[]> {
	const [rows] = await dbQuery<unknown[][]>(readQuery, {
		notification: Record("notification", id),
		user,
	})
	return rows
}

export async function markAllNotificationsRead(
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(readAllQuery, { user })
}
