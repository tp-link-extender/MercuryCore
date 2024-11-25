import { Record, db } from "$lib/server/surreal"
import type {
	Adapter,
	DatabaseSession,
	DatabaseUser,
	RegisteredDatabaseUserAttributes,
} from "lucia"
import deleteExpiredSessionsQuery from "./deleteExpiredSessions.surql"
import deleteUserSessionsQuery from "./deleteUserSessions.surql"
import getSessionAndUserQuery from "./getSessionAndUser.surql"
import getUserSessionsQuery from "./getUserSessions.surql"
import setSessionQuery from "./setSession.surql"

async function deleteSession(sessionId: string) {
	await db.delete(Record("session", sessionId))
}

async function deleteUserSessions(userId: string) {
	await db.query(deleteUserSessionsQuery, { user: Record("user", userId) })
}

async function getSessionAndUser(
	sessionId: string
): Promise<[session: DatabaseSession | null, user: DatabaseUser | null]> {
	const sess = Record("session", sessionId)

	const [session, user] = await db.query<
		[DatabaseSession | null, RegisteredDatabaseUserAttributes | null]
	>(getSessionAndUserQuery, { sess })

	if (session)
		session.expiresAt = new Date(
			(session.expiresAt as unknown as number) * 1000
		)

	return [session, user ? { id: user.id, attributes: user } : null]
}

async function setSession(session: DatabaseSession) {
	await db.query(setSessionQuery, {
		sess: Record("session", session.id),
		expiresAt: session.expiresAt,
		user: Record("user", session.userId),
	})
}

async function updateSessionExpiration(
	sessionId: string,
	expiresAt: Date
): Promise<void> {
	await db.merge(Record("session", sessionId), {
		expiresAt: Math.floor(expiresAt.getTime() / 1000),
	})
}

async function deleteExpiredSessions(): Promise<void> {
	await db.query(deleteExpiredSessionsQuery)
}

async function getUserSessions(userId: string) {
	const [result] = await db.query<DatabaseSession[][]>(getUserSessionsQuery, {
		user: Record("user", userId),
	})
	return result
}
export class SurrealAdapter implements Adapter {
	public deleteSession = deleteSession
	public deleteUserSessions = deleteUserSessions
	public getSessionAndUser = getSessionAndUser
	public getUserSessions = getUserSessions
	public setSession = setSession
	public updateSessionExpiration = updateSessionExpiration
	public deleteExpiredSessions = deleteExpiredSessions
}
