import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import listQuery from "./notifications/list.surql"
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
